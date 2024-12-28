// package com.example.news_site.controller;

// import jakarta.servlet.FilterChain;
// import jakarta.servlet.ServletException;
// import jakarta.servlet.ServletRequest;
// import jakarta.servlet.ServletResponse;
// import jakarta.servlet.annotation.WebFilter;
// import jakarta.servlet.http.HttpFilter;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;

// import java.io.IOException;

// @WebFilter("/*")
// public class CustomFilter extends HttpFilter {
//     @Override
//     public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
//         HttpServletRequest httpServletRequest = (HttpServletRequest) req;
//         HttpServletResponse httpServletResponse = (HttpServletResponse) res;
        
//         // 获取请求路径
//         String requestURI = httpServletRequest.getRequestURI();
        
//         // 检查是否访问管理页面
//         if (requestURI.contains("/pages/admin.jsp") || requestURI.contains("/pages/login.jsp")) {
//             // 重定向到首页或错误页
//             httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/pages/error.jsp");
//             return;
//         }
        
//         chain.doFilter(req, res);
//     }
// }