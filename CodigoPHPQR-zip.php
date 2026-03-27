<?php
/*
Plugin Name: Generador de Votaciones QR 
Description: Genera QRs de un solo uso y permite descargarlos en un ZIP.
Version: 1.1
Author: 
*/

register_activation_hook(__FILE__, 'crear_tabla_votos');
function crear_tabla_votos() {
    global $wpdb;
    $tabla = $wpdb->prefix . 'votos_tokens';

    $sql = "CREATE TABLE IF NOT EXISTS $tabla (
        id mediumint(9) NOT NULL AUTO_INCREMENT,
        token varchar(20) NOT NULL,
        usado tinyint(1) DEFAULT 0 NOT NULL,
        PRIMARY KEY (id)
    );";

    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
    dbDelta($sql);
}

add_action('admin_menu', 'crear_menu_votos');
function crear_menu_votos() {
    add_menu_page('Generador QR', 'Generador QR', 'manage_options', 'menu-qr-votos', 'pantalla_principal');
}

function pantalla_principal() {
    global $wpdb;
    $tabla = $wpdb->prefix . 'votos_tokens';
    ?>
    <div class="wrap">
        <h1>Generador de QR para Votaciones</h1>

        <div style="background: #fff; padding: 20px; border: 1px solid #ccd0d4; margin-bottom: 20px;">
            
            <!-- GENERAR TOKENS -->
            <form method="post">
                <label>¿Cuántos tokens nuevos generar?</label>
                <input type="number" name="cantidad" value="5" min="1">
                <input type="submit" name="boton_generar" class="button button-primary" value="Generar y Mostrar">
            </form>

            <hr>

            <form method="post" action="<?php echo admin_url('admin-post.php'); ?>">
                <input type="hidden" name="action" value="descargar_qr_zip">
                <input type="submit" class="button" value="Descargar TODOS los QR en un ZIP">
            </form>

        </div>

        <?php
        if (isset($_POST['boton_generar'])) {
            $cuantos = intval($_POST['cantidad']);

            echo "<div style='display: flex; flex-wrap: wrap;'>";

            for ($i = 0; $i < $cuantos; $i++) {
                $token = wp_generate_password(16, false);

                $wpdb->insert($tabla, array(
                    'token' => $token,
                    'usado' => 0
                ));

                $url = home_url() . "/?votar=" . $token;
                $qr_url = "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=" . urlencode($url);

                echo "<div style='border:1px solid #ccc; padding:10px; margin:5px; text-align:center; background:white;'>";
                echo "<img src='$qr_url' width='100'><br><strong>$token</strong>";
                echo "</div>";
            }

            echo "</div>";
        }
        ?>
    </div>
    <?php
}

add_action('admin_post_descargar_qr_zip', 'descargar_zip_votos');

function descargar_zip_votos() {

    if (!current_user_can('manage_options')) {
        wp_die('No autorizado');
    }

    // Aumentar el tiempo de ejecución y el límite de memoria para evitar el error 504 / 500
    set_time_limit(0);
    @ini_set('memory_limit', '256M');

    global $wpdb;
    $tabla = $wpdb->prefix . 'votos_tokens';
    $resultados = $wpdb->get_results("SELECT token FROM $tabla");

    if (!$resultados) {
        wp_die('No hay tokens disponibles');
    }

    $zip = new ZipArchive();
    $nombre_zip = 'qrs_votacion.zip';
    
    // Mejor usar el directorio de uploads de WP, si no es escribible se usa sys_get_temp_dir
    $upload_dir = wp_upload_dir();
    if (empty($upload_dir['error']) && is_writable($upload_dir['basedir'])) {
        $ruta_zip = wp_normalize_path($upload_dir['basedir'] . '/' . $nombre_zip);
    } else {
        $ruta_zip = wp_normalize_path(sys_get_temp_dir() . '/' . $nombre_zip);
    }

    if ($zip->open($ruta_zip, ZipArchive::CREATE | ZipArchive::OVERWRITE) === TRUE) {

        // Usar descargas concurrentes con curl_multi reduce drásticamente el tiempo y evita cuelgues
        if (function_exists('curl_multi_init')) {
            $lotes = array_chunk($resultados, 20); // lotes de 20 para no saturar la API

            foreach ($lotes as $lote) {
                $mh = curl_multi_init();
                $curl_handles = [];

                foreach ($lote as $fila) {
                    $token = $fila->token;
                    $url_voto = home_url() . "/?votar=" . $token;
                    $api_url = "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=" . urlencode($url_voto);

                    $ch = curl_init();
                    curl_setopt($ch, CURLOPT_URL, $api_url);
                    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
                    
                    curl_multi_add_handle($mh, $ch);
                    $curl_handles[$token] = $ch;
                }

                $active = null;
                do {
                    $mrc = curl_multi_exec($mh, $active);
                    if ($active) {
                        curl_multi_select($mh);
                    }
                } while ($active > 0 && $mrc == CURLM_OK);

                foreach ($curl_handles as $token => $ch) {
                    $contenido_qr = curl_multi_getcontent($ch);
                    if ($contenido_qr && strlen($contenido_qr) > 100) {
                        $zip->addFromString("qr_$token.png", $contenido_qr);
                    }
                    curl_multi_remove_handle($mh, $ch);
                    curl_close($ch);
                }
                curl_multi_close($mh);
            }
        } else {
            // Fallback secuencial si no hay cURL, con timeout expandido
            foreach ($resultados as $fila) {
                $token = $fila->token;
                $url_voto = home_url() . "/?votar=" . $token;
                $api_url = "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=" . urlencode($url_voto);

                $response = wp_remote_get($api_url, array('timeout' => 30));

                if (!is_wp_error($response)) {
                    $contenido_qr = wp_remote_retrieve_body($response);
                    if (!empty($contenido_qr)) {
                        $zip->addFromString("qr_$token.png", $contenido_qr);
                    }
                }
            }
        }

        $zip->close();

        // Limpiar buffers de salida para que no se corrompa el ZIP al descargar
        while (ob_get_level()) {
            ob_end_clean();
        }

        if (file_exists($ruta_zip)) {
            header('Content-Type: application/zip');
            header('Content-Disposition: attachment; filename="' . $nombre_zip . '"');
            header('Content-Length: ' . filesize($ruta_zip));
            header('Pragma: no-cache');
            header('Expires: 0');

            readfile($ruta_zip);
            unlink($ruta_zip);
            exit;
        } else {
            wp_die('Error: el ZIP no se creó en ' . $ruta_zip);
        }
    }

    wp_die('Error creando o abriendo el ZIP en ' . $ruta_zip);
}


add_action('init', 'validar_voto_final');

function validar_voto_final() {

    if (isset($_GET['votar'])) {

        global $wpdb;
        $tabla = $wpdb->prefix . 'votos_tokens';
        $token = sanitize_text_field($_GET['votar']);

        $fila = $wpdb->get_row(
            $wpdb->prepare("SELECT * FROM $tabla WHERE token = %s", $token)
        );

        if ($fila) {

            if ($fila->usado == 0) {

                $wpdb->update($tabla,
                    array('usado' => 1),
                    array('token' => $token)
                );

                wp_redirect('https://festivalesgastronomicos.es/');
                exit;

            } else {
                wp_die("<h1>ERROR</h1><p>Este código ya se usó.</p>");
            }

        } else {
            wp_die("<h1>ERROR</h1><p>Código no válido.</p>");
        }
    }
}