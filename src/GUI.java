import javax.swing.*;
import java.io.*;
import java.sql.*;
import java.util.LinkedList;

public class GUI {
    static String name = null;
    static String passwd = null;
    static Connection conn = null;
    static Statement stmt = null;
    static ResultSet rset = null;

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
    static JCheckBox bAddAusstattung;
    static JTextPane tpAusgabe;


    public static void main(String[] args) {
        // Frame Erstellen
        JFrame f = new JFrame();
        f.setTitle("YaGiSe Ferienwohnungssuche v0.0.4");

        f.setSize(600,800);
        f.setLayout(null);

        //Login Bildschirm
            //Button Erstellen
            bLogin = new JButton("Login");
            bLogin.addActionListener(e -> buttonloginClick());
            f.add(bLogin);
            bLogin.setBounds(200,580,200,40);
            //TextBox für Username
            tLogin = new JTextField("dbsys37");
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

        tAnreiseDatum = new JTextField("01.11.2021");
        tAnreiseDatum.setBounds(50,600,200,40);
        f.add(tAnreiseDatum);
        tAnreiseDatum.setVisible(false);

        lAbreise = new JLabel("Abreisedatum");
        lAbreise.setBounds(300,560,400,40);
        f.add(lAbreise);
        lAbreise.setVisible(false);

        tAbreiseDatum = new JTextField("21.11.2021");
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

        bAddAusstattung = new JCheckBox("Auswählen");
        bAddAusstattung.setBounds(200,420,100,20);
        f.add(bAddAusstattung);
        bAddAusstattung.setVisible(false);

        tpAusgabe = new JTextPane();
        tpAusgabe.setBounds(50,50,500,340);
        f.add(tpAusgabe);
        tpAusgabe.setVisible(false);

        f.setVisible(true);
    }

    private static void buttonloginClick() {
        //System.out.println(tLogin.getText());
        name = tLogin.getText();
        passwd = tLogin.getText();
        try {
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver()); 				// Treiber laden
            String url = "jdbc:oracle:thin:@oracle19c.in.htwg-konstanz.de:1521:ora19c"; // String für DB-Connection
            conn = DriverManager.getConnection(url, name, passwd); 						// Verbindung erstellen

            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); 			// Transaction Isolations-Level setzen
            conn.setAutoCommit(false);													// Kein automatisches Commit

            JOptionPane.showMessageDialog(null, "Successfully logged in!");

            bLogin.setVisible(false);
            tLogin.setVisible(false);
            bSearchStart.setVisible(true);
            tAnreiseDatum.setVisible(true);
            lAnreise.setVisible(true);
            tAbreiseDatum.setVisible(true);
            lAbreise.setVisible(true);
            cLand.setVisible(true);
            cAusstattung.setVisible(true);
            bAddAusstattung.setVisible(true);
            tpAusgabe.setVisible(true);
        } catch (SQLException se){														// SQL-Fehler abfangen
            System.out.println();
            System.out
                    .println("SQL Exception occurred while establishing connection to DBS: "
                            + se.getMessage());
            System.out.println("- SQL state  : " + se.getSQLState());
            System.out.println("- Message    : " + se.getMessage());
            System.out.println("- Vendor code: " + se.getErrorCode());
            System.out.println();
            System.out.println("EXITING WITH FAILURE ... !!!");
            System.out.println();
            try {
                conn.rollback();														// Rollback durchführen
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.exit(-1);
        }

    }


    private static void buttonSuchenClick() {
        try {
            stmt = conn.createStatement();

            String selectAusstattung = "";
            if (bAddAusstattung.isSelected()) {
                selectAusstattung = " AND fwa.bez='"+ cAusstattung.getSelectedItem().toString() +"'";
                System.out.println("Selected");
            }

            String anfangsdatum = tAnreiseDatum.getText();
            String enddatum = tAbreiseDatum.getText();

            String mySelectQuery = "SELECT DISTINCT fw.fwname, dFWb.Sterne " +
                    "FROM DBSYS20.Fwohnung fw, DBSYS20.Adresse adr, DBSYS20.FWhatA fwa, DBSYS20.durchschnFWBew dFWb" +
                    " WHERE fwa.fwname=fw.fwname" +
                    " AND fw.adressID=adr.adressID" +
                    " AND adr.lname='"+ cLand.getSelectedItem().toString() +"'" +
                    selectAusstattung +
                    " AND dFWb.Fwname=fw.fwname" +
                    " AND fw.fwname NOT IN (SELECT b.fwname FROM DBSYS20.Buchung b" +
                                            " WHERE (TO_DATE(b.anfang, 'DD.MM.YY') <= '"+ anfangsdatum + "' AND TO_DATE(b.ende, 'DD.MM.YY') >= '"+ enddatum + "')\n" +
                                            "OR (TO_DATE(b.anfang, 'DD.MM.YY') > '"+ anfangsdatum + "' AND TO_DATE(b.anfang, 'DD.MM.YY') < '"+ enddatum + "')\n" +
                                            "OR (TO_DATE(b.ende, 'DD.MM.YY') > '"+ anfangsdatum + "' AND TO_DATE(b.ende, 'DD.MM.YY') <= '"+ enddatum + "'))";

            System.out.println(mySelectQuery);
            rset = stmt.executeQuery(mySelectQuery);                                    // Query ausführen


            tpAusgabe.setText("");
            tAnreiseDatum.getText();
            tAbreiseDatum.getText();
            //ausstattungen;
            while (rset.next()) {
                tpAusgabe.setText(tpAusgabe.getText() +
                        "Ferienwohnung: " + rset.getString("fwname") +
                        "\t|\tAnzahl Sterne Bewertung: " + rset.getString("Sterne") + "\n");
            }

        }catch (SQLException se){														// SQL-Fehler abfangen
            System.out.println();
            System.out
                    .println("SQL Exception occurred while using DBS: "
                            + se.getMessage());
            System.out.println("- SQL state  : " + se.getSQLState());
            System.out.println("- Message    : " + se.getMessage());
            System.out.println("- Vendor code: " + se.getErrorCode());
            System.out.println();
            System.out.println("EXITING WITH FAILURE ... !!!");
            System.out.println();
            try {
                conn.rollback();														// Rollback durchführen
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.exit(-1);
        }
    }
}
