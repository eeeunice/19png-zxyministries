package da;

import domain.Feedback;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    private final DatabaseLink db;
    private final Connection conn;
    
    public FeedbackDAO() {
        db = new DatabaseLink();
        conn = db.getConnection();
    }
    
    // Generate next feedback ID
    public String getNextFeedbackId() {
        String nextId = "FB001"; // Default starting ID
        String sql = "SELECT MAX(FEEDBACKID) FROM FEEDBACK";
        
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            if (rs.next() && rs.getString(1) != null) {
                String lastId = rs.getString(1);
                int number = Integer.parseInt(lastId.substring(2)) + 1;
                nextId = String.format("FB%03d", number);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nextId;
    }
    
    // Add new feedback
    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO FEEDBACK (FEEDBACKID, CUSTOMERID, RATING, COMMENT, FEEDBACK_DATE) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, feedback.getFeedbackId());
            stmt.setString(2, feedback.getCustomerId());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getComment());
            stmt.setTimestamp(5, new Timestamp(feedback.getFeedbackDate().getTime()));
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            db.shutDown();
        }
    }
    
    // Get all feedback
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<Feedback>();
        String sql = "SELECT * FROM FEEDBACK ORDER BY FEEDBACK_DATE DESC";
        
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getString("FEEDBACKID"));
                feedback.setCustomerId(rs.getString("CUSTOMERID"));
                feedback.setRating(rs.getInt("RATING"));
                feedback.setComment(rs.getString("COMMENT"));
                feedback.setFeedbackDate(rs.getTimestamp("FEEDBACK_DATE"));
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.shutDown();
        }
        return feedbackList;
    }
}