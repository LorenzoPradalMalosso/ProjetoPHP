<?php
    $pageTitle = "Azimute | Jornada Escoteira";
    include "includes/header.php";
?>

<main id="inicio" class="home-page">
    <section class="hero-section">
        <div class="hero-copy">
            <h1>Sua jornada <span>escoteira</span> em um só <strong>lugar!</strong></h1>
            <p>
                Registre progressões, especialidades, conquistas e acompanhe
                sua evolução dentro do Movimento Escoteiro.
            </p>
            <div class="hero-actions">
                <a class="btn btn-outline" href="login.php">Entrar</a>
                <a class="btn btn-primary" href="cadastro.php">Crie sua Conta</a>
            </div>
        </div>

        <img class="hero-mark" src="assets/img/Logo_Claro.png" alt="">
    </section>

    <section class="how-section" aria-labelledby="como-funciona">
        <h2 id="como-funciona">Como <span>funciona?</span></h2>

        <div class="feature-grid">
            <article class="feature-card">
                <img src="assets/img/foto1.webp" alt="Escoteiros reunidos em atividade de integração">
                <div class="feature-content">
                    <h3>Registre</h3>
                    <p>Marque progressões, especialidades e conquistas.</p>
                </div>
            </article>

            <article class="feature-card">
                <img src="assets/img/foto2.webp" alt="Grupo escoteiro reunido ao ar livre">
                <div class="feature-content">
                    <h3>Acompanhe</h3>
                    <p>Visualize sua evolução em tempo real.</p>
                </div>
            </article>

            <article class="feature-card">
                <img src="assets/img/foto3.webp" alt="Escoteiros em acampamento">
                <div class="feature-content">
                    <h3>Conquiste</h3>
                    <p>Construa sua trajetória escoteira e registre seu legado.</p>
                </div>
            </article>
        </div>
    </section>

    <section class="preview-section" id="interface" aria-labelledby="perfil-preview">
        <div class="preview-copy">
            <h2 id="perfil-preview">Visualize como seria o <span>seu</span> perfil!</h2>
            <figure class="dashboard-frame">
                <img src="assets/img/dashboard_Preview.png" alt="Prévia da interface do dashboard Azimute">
            </figure>
        </div>

        <div class="mission-card">
            <h2>Qual é a nossa <strong>missão</strong><br>com o <span>Azimute?</span></h2>
            <p>
                O Azimute nasceu para ajudar jovens e escotistas a registrarem sua
                trajetória escoteira de forma simples, organizada e acessível.
            </p>
            <ul class="check-list">
                <li>Controle de etapas e objetivos.</li>
                <li>Registro organizado das especialidades.</li>
                <li>Linha do tempo da vida escoteira.</li>
                <li>Todas as informações em um só lugar.</li>
                <li>Acompanhe seu desenvolvimento.</li>
            </ul>
            <a class="btn btn-primary btn-wide" href="cadastro.php">Comece sua jornada agora!</a>
        </div>
    </section>

    <section class="about-section" id="sobre" aria-labelledby="sobre-azimute">
        <h2 id="sobre-azimute">Sobre</h2>

        <div class="about-grid">
            <article class="about-card about-card-green">
                <img class="about-icon" src="assets/icons/target-arrow 1.svg" alt="">
                <h3>Nosso Objetivo</h3>
                <p>
                    O Azimute nasceu com a missão de facilitar o acompanhamento da vida
                    escoteira, oferecendo uma plataforma simples, intuitiva e gratuita
                    para jovens e escotistas.
                </p>
            </article>

            <article class="about-card about-card-blue">
                <img class="about-icon" src="assets/icons/laptop-alt-2 1.svg" alt="">
                <h3>Quem Desenvolveu?</h3>
                <p>
                    O Azimute foi idealizado e desenvolvido por Lorenzo Pradal Malosso
                    como parte de um projeto acadêmico. Atualmente integrante do Ramo
                    Sênior, buscou criar uma ferramenta para auxiliar jovens.
                </p>
            </article>

            <article class="about-card about-card-green">
                <img class="about-icon" src="assets/icons/book-bookmark-minimalistic 1.svg" alt="">
                <h3>Motivações</h3>
                <p>
                    A inspiração para o Azimute surgiu da própria vivência no escotismo.
                    Participando do Movimento desde 2015, percebemos a importância de
                    preservar a história, as conquistas e a evolução de cada jovem.
                </p>
            </article>
        </div>
    </section>
</main>

<?php include "includes/footer.php"; ?>
