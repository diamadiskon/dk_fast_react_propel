import { useLogoutFunction } from '@propelauth/react';
import React from 'react';

function Navigation() {
    const logoutFn = useLogoutFunction();

    const navStyle = {
        position: "fixed",
        top: 0,
        left: 0,
        right: 0,
        zIndex: 1000,  // Adjust the z-index to control the stacking order
        backgroundColor: "#333",
        display: "flex",
        justifyContent: "space-between",
        alignItems: "center",
        padding: "10px",
    };

    const ulStyle = {
        listStyle: "none",
        display: "flex",
        alignItems: "center",
        margin: 0,
    };

    const liStyle = {
        marginRight: "20px",
    };

    const linkStyle = {
        color: "#fff",
        textDecoration: "none",
    };

    const logoutButtonStyle = {
        color: "#fff",
        backgroundColor: "transparent",
        border: "none",
        cursor: "pointer",
        textDecoration: "none",
    };

    return (
        <nav style={navStyle}>
            <div style={{ display: "flex", alignItems: "center" }}>
                <img src="https://pasteboard.co/ttmtj4NXkg5S.png" alt="logo" style={{ marginRight: "10px" }} />
                <h1 style={{ color: "#fff", fontSize: "24px", margin: 0 }}>My Health</h1>
            </div>
            <ul style={ulStyle}>
                <li style={liStyle}><a href="/" style={linkStyle}>Home</a></li>
                <li style={liStyle}><a href="/users" style={linkStyle}>Users</a></li>
                <li style={liStyle}><a href="/settings" style={linkStyle}>Settings</a></li>
                <li><button onClick={() => logoutFn(true)} style={logoutButtonStyle}>Logout</button></li>
            </ul>
        </nav>
    );
}

export default Navigation;
