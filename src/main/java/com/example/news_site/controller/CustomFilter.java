package com.example.news_site.controller;

import com.example.news_site.dao.UserID_DAO;
import com.example.news_site.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebFilter("/*")
public class CustomFilter extends HttpFilter {
    private UserID_DAO userID_dao;

    @Override
    public void init(FilterConfig config) throws ServletException {
        try {
            userID_dao = new UserID_DAO(DBConnection.getConnection());
        } catch (SQLException e) {
            throw new ServletException("Unable to initialize database", e);
        }
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpServletRequest = (HttpServletRequest) req;
        HttpServletResponse httpServletResponse = (HttpServletResponse) res;
        System.err.println("--------site*********");
        int userId = determineUserID(httpServletRequest, httpServletResponse);
        httpServletRequest.getSession().setAttribute("userId", userId);
        System.err.println("--------site---------");
        System.out.println(httpServletRequest.getRequestURL());
        System.out.println("requesting");
        chain.doFilter(req, res);
        System.out.println("responding");
        System.out.println(httpServletResponse.getStatus());
        System.err.println("********site---------");
    }

    /**
     * 从请求中获取用户ID
     * 如果没有，则生成一个新的用户ID
     *
     * @param request
     * @param response
     */

    private int determineUserID(
            HttpServletRequest request,
            HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        int userId = -1;
        if (cookies == null || cookies.length == 0) {
            // new user
            userId = plantUserId(userId, response);
            return userId;
        }
        for (Cookie cookie : cookies) {
            if (!cookie.getName().equals("userId"))
                //other irrelevant cookies
                continue;
            try {
                userId = Integer.parseInt(cookie.getValue());
                if (userID_dao.validateExistingID(userId))
                    // verified old user
                    return userId;
                // if the cookie is invalid, break and generate a new one
                break;
            } catch (RuntimeException ignored) {
                // if the cookie is invalid, break and generate a new one
                break;
            }
        }
        userId = plantUserId(userId, response);
        return userId;

    }

    private int plantUserId(int oldUserId, HttpServletResponse response) {
        if (oldUserId != -1) {
            return oldUserId;
        }
        int userId;
        userId = userID_dao.minFreeID();
        userID_dao.registerNewID(userId);
        Cookie cookie = new Cookie("userId", String.valueOf(userId));
        cookie.setMaxAge(60 * 60 * 24 * 365);
        response.addCookie(cookie);
        return userId;
    }
}
