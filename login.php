<?php
$db = new PDO('mysql:host=localhost;dbname=pharma', 'root', '');

if(isset($_POST['connect'])){

    // Récupérer les valeurs saisies
    $phone_saisi = $_POST['phone'];
    $mdp_saisi   = $_POST['mdp'];

    $req = $db->prepare('SELECT * FROM member WHERE member_phone = :phone');
    $req->execute([':phone' => $phone_saisi]);
    $membre = $req->fetch(PDO::FETCH_ASSOC);
    if($member){

        if($mdp_saisi == $member['member_mdp']){
          
            header('Location: member.php');
            exit();
        } else {
            $erreur = "Mot de passe incorrect.";
        }

    } else {
        $erreur = "Numéro de téléphone introuvable.";
    }
}
?>

<form method="POST" action="login.php">
    <input type="tel" placeholder="phone" name="phone" /><br />
    <input type="password" placeholder="Mot de passe" name="mdp" /><br />
    <?php if(isset($erreur)) echo "<p style='color:red;'>$erreur</p>"; ?>
    <input type="submit" value="Connexion" name="connect" />
</form>