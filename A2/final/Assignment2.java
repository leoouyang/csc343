import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {

    public Assignment2() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
        try{
			connection = DriverManager.getConnection(url+"?currentSchema=parlgov", username, password);
		}catch (SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
			return false;
		}
		return true;
    }

    @Override
    public boolean disconnectDB() {
        // Implement this method!
        try{
			connection.close();
		}catch (SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
			return false;
		}
		return true;
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
		List<Integer> elections = new ArrayList<Integer>();
		List<Integer> cabinets = new ArrayList<Integer>();
		
        try{
        	String queryString = "select id from country where name = ?";
			PreparedStatement ps = connection.prepareStatement(queryString);
			ps.setString(1,countryName);
			ResultSet rs = ps.executeQuery();
			rs.next();
			int countryID = rs.getInt("id");
		
	        queryString = "select id from election where country_id = ? order by extract(year from e_date) desc, id";
			ps = connection.prepareStatement(queryString);
			ps.setInt(1,countryID);
			rs = ps.executeQuery();
			while(rs.next()){
				elections.add(rs.getInt("id"));
			}
			
	        queryString = "select cabinet.id from cabinet left join election on cabinet.election_id=election.id where cabinet.country_id = ? order by extract(year from election.e_date) desc, election.id, extract(year from cabinet.start_date) ASC";
			ps = connection.prepareStatement(queryString);
			ps.setInt(1,countryID);
			rs = ps.executeQuery();
			while(rs.next()){
				cabinets.add(rs.getInt("id"));
			}
        }catch(SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
        }
		
		ElectionCabinetResult result = new ElectionCabinetResult(elections, cabinets);
		return result;
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
    	List<Integer> result = new ArrayList<Integer>();
    	try{
        	String queryString = "select comment,description from politician_president where id = ?";
			PreparedStatement ps = connection.prepareStatement(queryString);
			ps.setInt(1,politicianName);
			ResultSet rs = ps.executeQuery();
			rs.next();
			String givenPresident = rs.getString("comment") + " " + rs.getString("description");
			
			queryString = "select id,comment,description from politician_president where id != ?";
			ps = connection.prepareStatement(queryString);
			ps.setInt(1,politicianName);
			rs = ps.executeQuery();
			while(rs.next()){
				double similarity = similarity(givenPresident, rs.getString("comment") + " " + rs.getString("description"));
				if (similarity >= threshold){
					result.add(rs.getInt("id"));
				}
			}
    	}catch(SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
        }
    	return result;
    }
	
    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
		String url = "jdbc:postgresql://localhost:5432/csc343h-ouyangz2";
		try{
			Assignment2 tester = new Assignment2();
			boolean connResult = tester.connectDB(url, "ouyangz2", "");
			System.out.println("connection is " + connResult);
			//ElectionCabinetResult result = tester.electionSequence("Canada");
			List<Integer> result = tester.findSimilarPoliticians(9, (float)0.1);
			System.out.println(result);
			boolean disconnResult = tester.disconnectDB();
			System.out.println("disconnection is " + disconnResult);
		}catch(ClassNotFoundException e){
			
		}
    }

}

