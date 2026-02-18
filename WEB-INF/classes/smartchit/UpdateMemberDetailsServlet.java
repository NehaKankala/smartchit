package smartchit;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class UpdateMemberDetailsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        int memberId = Integer.parseInt(req.getParameter("member_id"));
        String name = req.getParameter("name");
        String mobile = req.getParameter("mobile");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE members SET name=?, mobile=? WHERE member_id=?"
            );

            ps.setString(1, name);
            ps.setString(2, mobile);
            ps.setInt(3, memberId);

            ps.executeUpdate();

            res.getWriter().write("success");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}

