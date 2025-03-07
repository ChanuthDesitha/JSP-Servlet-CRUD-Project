package com.example.demo11.dao;

import com.example.demo11.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.example.demo11.util.DBConnection.getConnection;

public class UserDAO {

    public boolean addUser(User user) {
        boolean result = false;
        String query = "INSERT INTO users (name, email, password, mobile, photo) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashPassword(user.getPassword()));
            ps.setString(4, user.getMobile());

            if (user.getPhoto() != null) {
                ps.setBlob(5, user.getPhoto());
            } else {
                ps.setNull(5, Types.BLOB);
            }

            int rowsAffected = ps.executeUpdate();
            result = rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery();){


            while (rs.next()) {
                InputStream imageStream = rs.getBinaryStream("photo");
                users.add(new User(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("mobile"),
                        imageStream
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean deleteUser(int id) {
        String query = "DELETE FROM users WHERE id=?";
        boolean success = false;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean emailExists(String email) {
        String query = "SELECT id FROM users WHERE email = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // True if email found
            }

        } catch (SQLException e) {
            System.err.println("Error checking if email exists: " + e.getMessage());
            e.printStackTrace();
            return false; // In case of error, assume email does not exist to avoid accidental blocking
        }
    }

    public boolean updateUser(User user, InputStream imageStream) {
        boolean success = false;
        String query;

        if (imageStream != null) {
            query = "UPDATE users SET name = ?, email = ?, password = ?, mobile = ?, photo = ? WHERE id = ?";
        } else {
            query = "UPDATE users SET name = ?, email = ?, password = ?, mobile = ? WHERE id = ?";
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashPassword(user.getPassword()));
            ps.setString(4, user.getMobile());

            if (imageStream != null) {
                ps.setBlob(5, imageStream);
                ps.setInt(6, user.getId());
            } else {
                ps.setInt(5, user.getId());
            }

            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public User getUserById(int Id) {
        User user = null;
        String query = "SELECT * FROM users WHERE id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, Id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("mobile"),
                        rs.getBinaryStream("photo")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean authenticateUser(String email, String password) {
        boolean success = false;

        String query = "SELECT password FROM users WHERE email = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                success = BCrypt.checkpw(password,storedHash);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    private String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

}