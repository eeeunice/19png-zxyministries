<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review History</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a5d42;
            --primary-hover: #144532;
            --secondary-color: #f8f9fa;
            --accent-color: #28a745;
            --text-color: #333;
            --light-gray: #e9ecef;
            --border-radius: 8px;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: var(--text-color);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column; /* Changed to column */
            align-items: center;
            padding: 20px;
        }

        .container {
            background-color: #fff;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            width: 95%;
            max-width: 1200px; /* Increased max-width */
            overflow: hidden;
            margin-bottom: 20px; /* Added margin */
        }

        .header {
            background-color: var(--primary-color);
            color: white;
            padding: 20px 30px;
            position: relative;
        }

        .header h1 {
            text-align: center;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .header p {
            text-align: center;
            opacity: 0.9;
            font-size: 16px;
        }

        .table-container {
            padding: 20px;
            overflow-x: auto; /* Enable horizontal scrolling */
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: var(--light-gray);
            font-weight: 600;
            color: var(--text-color);
        }

        tbody tr:hover {
            background-color: #f5f5f5;
        }

        .review-image {
            max-width: 100px;
            height: auto;
            border-radius: var(--border-radius);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: block;
            margin: 0 auto;
        }

        .no-reviews {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            padding: 20px;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
            }

            .header h1 {
                font-size: 24px;
            }

            th, td {
                padding: 8px 10px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Review History</h1>
            <p>Your submitted reviews</p>
        </div>

        <div class="table-container">
            <c:choose>
                <c:when test="${not empty reviews}">
                    <table>
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Product ID</th>
                                <th>Rating</th>
                                <th>Comments</th>
                                <th>Image</th>
                                <th>Review Date</th>
                                <th>Reply from Staff</th>
                                <th>Reply Date</th>
                                <th>Reply By</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="review" items="${reviews}">
                                <tr>
                                    <td>${review.orderId}</td>
                                    <td>${review.productId}</td>
                                    <td>${review.rating}</td>
                                    <td>${review.comments}</td>
                                    <td>
                                        <c:if test="${not empty review.imageUrl}">
                                            <img src="${review.imageUrl}" alt="Review Image" class="review-image">
                                        </c:if>
                                    </td>
                                    <td>${review.reviewDate}</td>
                                    <td>${review.reply}</td>
                                    <td>${review.replyAt}</td>
                                    <td>${review.replyBy}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="no-reviews">No reviews found.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>