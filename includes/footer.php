<?php
    if (!isset($basePath)) {
        $scriptDir = trim(str_replace("\\", "/", dirname($_SERVER["SCRIPT_NAME"] ?? "")), "/");
        $basePath = basename($scriptDir) === "pages" ? "../" : "";
    }
?>
    <footer class="site-footer">
        <div class="footer-main">
            <a class="footer-brand" href="<?= $basePath ?>index.php" aria-label="Página inicial da Azimute">
                <img class="footer-symbol" src="<?= $basePath ?>assets/img/Logo_Escuro.png" alt="">
                <img class="footer-wordmark" src="<?= $basePath ?>assets/img/Nome_Slogan_Escuro.png" alt="Azimute. Sua jornada, seu rumo, seu legado. Vida escoteira, progressão, conquistas">
            </a>

            <div class="footer-highlights" aria-label="Diferenciais da Azimute">
                <div class="footer-highlight">
                    <img src="<?= $basePath ?>assets/icons/people 1.svg" alt="">
                    <div>
                        <strong>Feito por Escoteiros</strong>
                        <span>Desenvolvido com amor e propósito escoteiro.</span>
                    </div>
                </div>

                <div class="footer-highlight">
                    <img src="<?= $basePath ?>assets/icons/heart 1.svg" alt="">
                    <div>
                        <strong>100% Gratuito</strong>
                        <span>Desenvolvido com amor e propósito escoteiro.</span>
                    </div>
                </div>

                <div class="footer-highlight">
                    <img src="<?= $basePath ?>assets/icons/shield-alt 1.svg" alt="">
                    <div>
                        <strong>Seguro e Confiável</strong>
                        <span>Seus dados protegidos com responsabilidade.</span>
                    </div>
                </div>
            </div>

            <div class="footer-contact">
                <strong>Contato</strong>
                <div class="footer-socials">
                    <a href="#" aria-label="Instagram">
                        <img src="<?= $basePath ?>assets/icons/instagram 2.svg" alt="">
                    </a>
                    <a href="#" aria-label="WhatsApp">
                        <img src="<?= $basePath ?>assets/icons/whatsapp 1.svg" alt="">
                    </a>
                    <a href="mailto:contato@azimute.local" aria-label="Email">
                        <img src="<?= $basePath ?>assets/icons/mail 1.svg" alt="">
                    </a>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <span class="footer-world">
                <img src="<?= $basePath ?>assets/icons/fleur-de-lis-2 1.svg" alt="">
                Construindo um mundo melhor.
            </span>
            <span>&copy; <?= date("Y") ?> Azimute. Todos os direitos reservados</span>
            <span>Projeto sem fins lucrativos.</span>
        </div>
    </footer>
</body>
</html>
