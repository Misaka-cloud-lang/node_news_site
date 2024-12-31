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

@WebFilter("/*")
public class CustomFilter extends HttpFilter {
    private UserID_DAO userID_dao;

    @Override
    public void init(FilterConfig config) throws ServletException {
        userID_dao = new UserID_DAO(DBConnection.getConnection());
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpServletRequest = (HttpServletRequest) req;
        HttpServletResponse httpServletResponse = (HttpServletResponse) res;
        determineUserID(httpServletRequest, httpServletResponse);
        System.out.println(httpServletRequest);
        System.out.println("requesting");
        System.out.println(httpServletResponse);
    }

    /**
     * 从请求中获取用户ID
     * 如果没有，则生成一个新的用户ID
     *
     * @param request
     * @param response
     */

    private void determineUserID(
            HttpServletRequest request,
            HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        int userId = -1;
        if (cookies == null || cookies.length == 0) {
            userId = userID_dao.minFreeID();
            userID_dao.registerNewID(userId);
            Cookie cookie = new Cookie("userId", String.valueOf(userId));
            cookie.setMaxAge(60 * 60 * 24 * 365);
            response.addCookie(cookie);
        } else {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = Integer.parseInt(cookie.getValue());
                    break;
                }
            }
            if (userId == -1) {
                userId = userID_dao.minFreeID();
                userID_dao.registerNewID(userId);
                Cookie cookie = new Cookie("userId", String.valueOf(userId));
                cookie.setMaxAge(60 * 60 * 24 * 365);
                response.addCookie(cookie);
            }
        }


    }
}
