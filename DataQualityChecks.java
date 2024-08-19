import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class DataQualityChecks {

    // Filling grade of an attribute (% share of values / nulls)
    public Map<String, Double> calculateFillingGrade(Connection conn, String attributeName, String viewName) throws SQLException {
        Map<String, Double> fillingGradeMap = new HashMap<>();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(" + attributeName + "), COUNT(*) FROM " + viewName);
        if (rs.next()) {
            double filledCount = rs.getDouble(1);
            double totalCount = rs.getDouble(2);
            double fillingGrade = (filledCount / totalCount) * 100;
            fillingGradeMap.put(attributeName, fillingGrade);
        }
        rs.close();
        stmt.close();
        return fillingGradeMap;
    }

    // Value distribution (top x values and % share)
    public Map<String, Double> calculateValueDistribution(Connection conn, String attributeName, String viewName, int topX) throws SQLException {
        Map<String, Double> valueDistributionMap = new HashMap<>();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT " + attributeName + ", COUNT(*) FROM " + viewName + " GROUP BY " + attributeName + " ORDER BY COUNT(*) DESC LIMIT " + topX);
        while (rs.next()) {
            String value = rs.getString(1);
            double count = rs.getDouble(2);
            double percentageShare = (count / getTotalCount(conn, viewName)) * 100;
            valueDistributionMap.put(value, percentageShare);
        }
        rs.close();
        stmt.close();
        return valueDistributionMap;
    }

    //Total count
    private double getTotalCount(Connection conn, String viewName) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + viewName);
        if (rs.next()) {
            return rs.getDouble(1);
        }
        return 0;}

    // Lowest value
    public String getLowestValue(Connection conn, String attributeName, String viewName) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT MIN(" + attributeName + ") FROM " + viewName);
        String lowestValue = "";
        if (rs.next()) {
            lowestValue = rs.getString(1);
        }
        rs.close();
        stmt.close();
        return lowestValue;
    }

    // Highest value
    public String getHighestValue(Connection conn, String attributeName, String viewName) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT MAX(" + attributeName + ") FROM " + viewName);
        String highestValue = "";
        if (rs.next()) {
            highestValue = rs.getString(1);
        }
        rs.close();
        stmt.close();
        return highestValue;
    }

    // Average value
    public double getAverageValue(Connection conn, String attributeName, String viewName) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT AVG(" + attributeName + ") FROM " + viewName);
        double averageValue = 0;
        if (rs.next()) {
            averageValue = rs.getDouble(1);
        }
        rs.close();
        stmt.close();
        return averageValue;
    }

   /*  // Format patterns (top x patterns used and % share)
    public Map<String, Double> calculateFormatPatterns(Connection conn, String attributeName, String viewName, int topX) throws SQLException {
        Map<String, Double> formatPatternMap = new HashMap<>();
        // Add logic to analyze format patterns
        // Example: using regular expressions to identify patterns
        return formatPatternMap;
    }

    // Recommend standard format patterns (based on share of identified patterns)
    public String recommendStandardFormatPattern(Map<String, Double> formatPatternMap) {
        // Add logic to recommend standard format patterns based on the share of identified patterns
        return "yyyy-MM-dd";
    }

    // Count values with incorrect format/pattern
    public int countIncorrectFormatValues(Connection conn, String attributeName, String viewName, String expectedPattern) throws SQLException {
        int incorrectFormatCount = 0;
        // Add logic to count values with incorrect format/pattern
        return incorrectFormatCount;
    }*/

   
    public boolean performForeignKeyReferenceCheck(Connection conn, String viewName, String referenceTable, String foreignKeyColumn) throws SQLException {
            Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + viewName + " WHERE " + foreignKeyColumn + " NOT IN (SELECT " + foreignKeyColumn + " FROM " + referenceTable + ")");
    if (rs.next()) {
        int invalidForeignKeyCount = rs.getInt(1);
        rs.close();
        stmt.close();
        return invalidForeignKeyCount == 0;
    }
        return false;
    }

    
}

/*import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        String url = "jdbc://localhost:/database";
        String user = "username";
        String password = "password";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            DataQualityChecks dataQualityChecks = new DataQualityChecks();

            // Example usage of data quality checks
            String viewName = "your_view_name";
            String attributeName = "your_attribute_name";
            String referenceTable = "your_reference_table";
            String foreignKeyColumn = "your_foreign_key_column";

            System.out.println("Filling grade: " + dataQualityChecks.calculateFillingGrade(conn, attributeName, viewName));
            System.out.println("Value distribution: " + dataQualityChecks.calculateValueDistribution(conn, attributeName, viewName, 5));
            System.out.println("Lowest value: " + dataQualityChecks.getLowestValue(conn, attributeName, viewName));
            System.out.println("Highest value: " + dataQualityChecks.getHighestValue(conn, attributeName, viewName));
            System.out.println("Average value: " + dataQualityChecks.getAverageValue(conn, attributeName, viewName));
            System.out.println("Format patterns: " + dataQualityChecks.calculateFormatPatterns(conn, attributeName, viewName, 5));
            System.out.println("Recommended format pattern: " + dataQualityChecks.recommendStandardFormatPattern(null));
            System.out.println("Count of incorrect format values: " + dataQualityChecks.countIncorrectFormatValues(conn, attributeName, viewName, "expected_pattern"));
            System.out.println("Foreign key reference check: " + dataQualityChecks.performForeignKeyReferenceCheck(conn, viewName, referenceTable, foreignKeyColumn));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}*/