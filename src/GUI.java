import javax.swing.*;
import java.awt.event.WindowEvent;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.LinkedList;

public class GUI {
    static String email = null;
    static Connection conn = null;
    static Statement stmt = null;
    static ResultSet rset = null;

    //Login Bildschirm
    static JButton bLogin;
    static JTextField tLogin;
    static JLabel ltodaysDate;
    static String todayDate;

    //Hauptbildschirm
    static JButton bSearchStart;
    static JLabel lAnreise;
    static JTextField tAnreiseDatum;
    static JLabel lAbreise;
    static JTextField tAbreiseDatum;
    static JComboBox cLand;
    static JComboBox cAusstattung;
    static JCheckBox bAddAusstattung;
    static JList<String> tpAusgabe;
    static DefaultListModel<String> model;

    static JButton bBuchen;

    static String anfangDatum;
    static String endeDatum;


    public static void main(String[] args) {
        // Frame Erstellen
        JFrame f = new JFrame();

        f.addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(WindowEvent winEvt) {
                try {
                    if (!tLogin.isVisible()) {
                        conn.close();
                    }
                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
                System.exit(0);
            }});

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
            tLogin = new JTextField("maxmuster@gmail.com");
            f.add(tLogin);
            tLogin.setBounds(200,550,200,20);

            todayDate = new SimpleDateFormat("dd.MM.YYYY").format(Calendar.getInstance().getTime());
            ltodaysDate = new JLabel(todayDate);
            ltodaysDate.setBounds(500,720,100,20);
            f.add(ltodaysDate);

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
        cLand.setBounds(50,450,100,40);
        f.add(cLand);
        cLand.setVisible(false);

        cAusstattung = new JComboBox();
        cAusstattung.setBounds(200,450,100,40);
        f.add(cAusstattung);
        cAusstattung.setVisible(false);

        bAddAusstattung = new JCheckBox("Auswählen");
        bAddAusstattung.setBounds(200,420,100,20);
        f.add(bAddAusstattung);
        bAddAusstattung.setVisible(false);

        model = new DefaultListModel<>();
        tpAusgabe = new JList<>(model);
        tpAusgabe.setBounds(50,50,500,340);
        f.add(tpAusgabe);
        tpAusgabe.setVisible(false);

        bBuchen = new JButton("Buchen!");
        bBuchen.setBounds(50,700,450,40);
        bBuchen.addActionListener(e -> buttonBuchenClick());
        f.add(bBuchen);
        bBuchen.setEnabled(false);
        bBuchen.setVisible(false);

        f.setVisible(true);
    }

    private static void buttonloginClick() {
        //System.out.println(tLogin.getText());
        email = tLogin.getText();
        try {
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver()); 				// Treiber laden
            String url = "jdbc:oracle:thin:@oracle19c.in.htwg-konstanz.de:1521:ora19c"; // String für DB-Connection
            conn = DriverManager.getConnection(url, "dbsys37", "dbsys37"); 						// Verbindung erstellen

            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); 			// Transaction Isolations-Level setzen
            conn.setAutoCommit(false);													// Kein automatisches Commit

            stmt = conn.createStatement();

            String mySelectQuery0 = "SELECT k.email FROM DBSYS20.Kunde k WHERE k.email = '" + email + "'";
            System.out.println(mySelectQuery0);
            rset = stmt.executeQuery(mySelectQuery0);                                    // Query ausführen
            if (!rset.next()) {
                JOptionPane.showMessageDialog(null, "User not Found!");
                conn.close();
            } else {

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
                bBuchen.setVisible(true);


                String mySelectQuery1 = "SELECT a.bez FROM DBSYS20.Ausstattung a";
                System.out.println(mySelectQuery1);
                rset = stmt.executeQuery(mySelectQuery1);                                    // Query ausführen
                while (rset.next()) {
                    cAusstattung.addItem(rset.getString("bez"));
                }

                String mySelectQuery2 = "SELECT l.lname FROM DBSYS20.Land l";
                System.out.println(mySelectQuery2);
                rset = stmt.executeQuery(mySelectQuery2);                                    // Query ausführen
                while (rset.next()) {
                    cLand.addItem(rset.getString("lname"));
                }

            }
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

            anfangDatum = tAnreiseDatum.getText();
            endeDatum = tAbreiseDatum.getText();

            String mySelectQuery = "SELECT DISTINCT fw.fwname, dFWb.Sterne " +
                    "FROM DBSYS20.Fwohnung fw, DBSYS20.Adresse adr, DBSYS20.FWhatA fwa, DBSYS20.durchschnFWBew dFWb" +
                    " WHERE fwa.fwname=fw.fwname" +
                    " AND fw.adressID=adr.adressID" +
                    " AND adr.lname='"+ cLand.getSelectedItem().toString() +"'" +
                    selectAusstattung +
                    " AND dFWb.Fwname=fw.fwname" +
                    " AND fw.fwname NOT IN (SELECT b.fwname FROM DBSYS20.Buchung b" +
                                            " WHERE (TO_DATE(b.anfang, 'DD.MM.YY') <= '"+ anfangDatum + "' AND TO_DATE(b.ende, 'DD.MM.YY') >= '"+ endeDatum + "')\n" +
                                            "OR (TO_DATE(b.anfang, 'DD.MM.YY') > '"+ anfangDatum + "' AND TO_DATE(b.anfang, 'DD.MM.YY') < '"+ endeDatum + "')\n" +
                                            "OR (TO_DATE(b.ende, 'DD.MM.YY') > '"+ anfangDatum + "' AND TO_DATE(b.ende, 'DD.MM.YY') <= '"+ endeDatum + "'))";

            System.out.println(mySelectQuery);
            rset = stmt.executeQuery(mySelectQuery);                                    // Query ausführen

            model.clear();
            //ausstattungen;
            while (rset.next()) {
                model.addElement(rset.getString("fwname") + ":" + rset.getString("Sterne"));
            }

            if (!model.isEmpty()) {
                bBuchen.setEnabled(true);
            } else {
                bBuchen.setEnabled(false);
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

    private static void buttonBuchenClick() {
        try {
            stmt = conn.createStatement();
            //INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
            //VALUES(bnmr_ID.NextVal, '05.12.2021', '21.11.2021', 0, '30.10.2021', '06.12.2021', 5, '03.11.2021', rnmr_ID.NextVal, 150, 'hannahall@gmail.com', 'Jupiterhaus');

            if(!anfangDatum.equals(tAnreiseDatum.getText()) || !endeDatum.equals(tAbreiseDatum.getText())) {
                JOptionPane.showMessageDialog(null, "Du Schlingel! Hier wird nicht gehackt!");
                conn.close();
                System.exit(1);
            }

            int fwpreis = 0;
            String[] fwn = tpAusgabe.getSelectedValue().split(":");

            String mySelectGetFWPriceQueary = "SELECT fw.preis FROM DBSYS20.Fwohnung fw " +
                    "WHERE fw.fwname ='" + fwn[0] + "'";
            System.out.println(mySelectGetFWPriceQueary);
            rset = stmt.executeQuery(mySelectGetFWPriceQueary);
            while (rset.next()) {
                fwpreis = rset.getInt("preis");
            }

            String myInsertQuery = "INSERT INTO DBSYS20.Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname) " +
                    "VALUES(DBSYS20.bnmr_ID.NextVal, '" + endeDatum + "', '" + anfangDatum + "', 0, '" + todayDate + "', NULL, NULL, NULL, NULL, "+ fwpreis +", '"+email+"', '"+fwn[0]+"')";

            System.out.println(myInsertQuery);
            rset = stmt.executeQuery(myInsertQuery);                                    // Query ausführen
            System.out.println(rset);

            System.out.println("commit;");
            stmt.executeQuery("commit");
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

/* Hinzugefügt in Datenbank:
CREATE OR REPLACE VIEW durchschnFWBew(Fwname, Sterne) AS
SELECT fw.fwname, AVG(b.Stern)
FROM DBSYS20.FWohnung fw LEFT OUTER JOIN DBSYS20.Buchung b ON fw.fwname = b.fwname
GROUP BY fw.fwname;

GRANT SELECT
ON durchschnFWBew
TO dbsys37;

GRANT SELECT, ALTER
ON bnmr_ID
TO dbsys37;

GRANT SELECT, ALTER
ON rnmr_ID
TO dbsys37;

 */
