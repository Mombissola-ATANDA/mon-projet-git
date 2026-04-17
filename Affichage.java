import java.util.Scanner;

public class Affichage {
    public static void main(String[] args) {
        Scanner lecteur = new Scanner(System.in);

       
        Animal a = new Animal(); 
        a.nom = "Rex le chien";

        Personne p = new Personne(); 
        p.nom = "Jean";

        Oiseau o = new Oiseau(); 
        o.nom = "bel le perroquet";

        Poisson n = new Poisson(); 
        n.nom = "Sam le requin";

        Serpent s = new Serpent(); 
        s.nom = "Kaa le python";

        System.out.println("Que voulez-vous afficher ?");
        int choix = lecteur.nextInt();


        if (choix == 1) {
            System.out.println("Je suis  " + a.nom);
            a.seDeplacer();    
            a.sExplimer();  
        } 
        else if (choix == 2) {
            System.out.println("Je suis " + p.nom);
            p.seDeplacer();    
            p.sExplimer();  
          
        } 
        else if (choix == 3) {
            System.out.println("Je suis " + o.nom);
            o.seDeplacer();    
            o.sExplimer();       
           
        } 
        else if (choix == 4) {
            System.out.println("Je suis " + n.nom);
            n.seDeplacer();    
            n.sExplimer();  
            
        } 
        else if (choix == 5) {
            System.out.println("Je suis " + s.nom);
            s.seDeplacer();    
            s.sExplimer();  
            
        } 
        else {
            System.out.println("Erreur ");
        }

        lecteur.close();
    }
}