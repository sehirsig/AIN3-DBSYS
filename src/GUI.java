import javax.swing.*;

public class GUI {
    //Login Bildschirm
    static JButton bLogin;
    static JTextField tLogin;

    //Hauptbildschirm
    static JButton bSearchStart;
    static JLabel lAnreise;
    static JTextField tAnreiseDatum;
    static JLabel lAbreise;
    static JTextField tAbreiseDatum;
    static JComboBox cLand;
    static JComboBox cAusstattung;
    static JTextPane tpAusstattung;
    static JButton bAddAusstattung;
    static JButton bDeleteAusstattung;

    static JTextPane tpAusgabe;


    public static void main(String[] args) {
        // Frame Erstellen
        JFrame f = new JFrame();

        f.setSize(600,800);
        f.setLayout(null);

        //Login Bildschirm
            //Button Erstellen
            bLogin = new JButton("click");
            bLogin.addActionListener(e -> buttonloginClick());
            f.add(bLogin);
            bLogin.setBounds(200,580,200,40);
            //TextBox für Username
            tLogin = new JTextField("Login");
            f.add(tLogin);
            tLogin.setBounds(200,550,200,20);

        //Haupt Bildschirm
        bSearchStart = new JButton("Suchen!");
        bSearchStart.setBounds(50,650,450,40);
        bSearchStart.addActionListener(e -> buttonSuchenClick());
        f.add(bSearchStart);
        bSearchStart.setVisible(false);

        lAnreise = new JLabel("Anreisedatum");
        lAnreise.setBounds(50,560,400,40);
        f.add(lAnreise);
        lAnreise.setVisible(false);

        tAnreiseDatum = new JTextField("DD.MM.YYYY");
        tAnreiseDatum.setBounds(50,600,200,40);
        f.add(tAnreiseDatum);
        tAnreiseDatum.setVisible(false);

        lAbreise = new JLabel("Abreisedatum");
        lAbreise.setBounds(300,560,400,40);
        f.add(lAbreise);
        lAbreise.setVisible(false);

        tAbreiseDatum = new JTextField("DD.MM.YYYY");
        tAbreiseDatum.setBounds(300,600,200,40);
        f.add(tAbreiseDatum);
        tAbreiseDatum.setVisible(false);

        cLand = new JComboBox();
        cLand.addItem("Deutschland");
        cLand.addItem("Österreich");
        cLand.addItem("Schweiz");
        cLand.addItem("Spanien");
        cLand.setBounds(50,450,100,40);
        f.add(cLand);
        cLand.setVisible(false);

        cAusstattung = new JComboBox();
        cAusstattung.addItem("Sauna");
        cAusstattung.addItem("Pool");
        cAusstattung.addItem("Balkon");
        cAusstattung.addItem("Gym");
        cAusstattung.setBounds(200,450,100,40);
        f.add(cAusstattung);
        cAusstattung.setVisible(false);

        tpAusstattung = new JTextPane();
        tpAusstattung.setBounds(360,400,100,100);
        f.add(tpAusstattung);
        tpAusstattung.setVisible(false);

        bAddAusstattung = new JButton("Hinzufügen");
        bAddAusstattung.setBounds(200,420,100,20);
        f.add(bAddAusstattung);
        bAddAusstattung.addActionListener(e -> buttonAddAusstattungClick());
        bAddAusstattung.setVisible(false);

        bDeleteAusstattung = new JButton("Löschen");
        bDeleteAusstattung.setBounds(360,500,100,20);
        f.add(bDeleteAusstattung);
        bDeleteAusstattung.addActionListener(e -> buttonDeleteAusstattungClick());
        bDeleteAusstattung.setVisible(false);

        tpAusgabe = new JTextPane();
        tpAusgabe.setBounds(50,50,500,340);
        f.add(tpAusgabe);
        tpAusgabe.setVisible(false);

        f.setVisible(true);
    }

    private static void buttonloginClick() {
        System.out.println(tLogin.getText());
        JOptionPane.showMessageDialog(null, "Successfull logged in!");

        bLogin.setVisible(false);
        tLogin.setVisible(false);
        bSearchStart.setVisible(true);
        tAnreiseDatum.setVisible(true);
        lAnreise.setVisible(true);
        tAbreiseDatum.setVisible(true);
        lAbreise.setVisible(true);
        cLand.setVisible(true);
        cAusstattung.setVisible(true);
        tpAusstattung.setVisible(true);
        bAddAusstattung.setVisible(true);
        bDeleteAusstattung.setVisible(true);
        tpAusgabe.setVisible(true);
    }

    private static void buttonAddAusstattungClick() {
        if (tpAusstattung.getText().isEmpty()) {
            tpAusstattung.setText(cAusstattung.getSelectedItem().toString());
        } else {
            if (!tpAusstattung.getText().contains(cAusstattung.getSelectedItem().toString())) {
                tpAusstattung.setText(tpAusstattung.getText() + "\n" + cAusstattung.getSelectedItem().toString());
            }
        }
    }

    private static void buttonDeleteAusstattungClick() {
        tpAusstattung.setText("");
    }

    private static void buttonSuchenClick() {
    }
}
