// Navigation.js
import React from 'react';

function Navigation() {
    return (
        <nav style={{ backgroundColor: "#333", display: "flex", justifyContent: "space-between", alignItems: "center", padding: "10px" }}>
            <div style={{ display: "flex", alignItems: "center" }}>
                <img src="https://via.placeholder.com/50x50" alt="logo" style={{ marginRight: "10px" }} />
                <h1 style={{ color: "#fff", fontSize: "24px", margin: 0 }}>My Health</h1>
            </div>
            <ul style={{ listStyle: "none", display: "flex", alignItems: "center", margin: 0 }}>
                <li style={{ marginRight: "20px" }}><a href="/" style={{ color: "#fff", textDecoration: "none" }}>Home</a></li>
                <li style={{ marginRight: "20px" }}><a href="/users" style={{ color: "#fff", textDecoration: "none" }}>Users</a></li>
                <li style={{ marginRight: "20px" }}><a href="/settings" style={{ color: "#fff", textDecoration: "none" }}>Settings</a></li>
                <li><a href="/logout" style={{ color: "#fff", textDecoration: "none" }}>Logout</a></li>
            </ul>
        </nav>
    );
}

export default Navigation;