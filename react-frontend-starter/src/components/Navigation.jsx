// Navigation.js
import React from 'react';

function Navigation() {
    return (
        <nav>
            <ul>
                <li><a href="/">Home</a></li>
                <li><a href="/users">Users</a></li>
                <li><a href="/settings">Settings</a></li>
                <li><a href="/logout">Logout</a></li>
            </ul>
        </nav>
    );
}

export default Navigation;