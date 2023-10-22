import { useLogoutFunction } from '@propelauth/react';
import React from 'react';

function Navigation() {
    const logoutFn = useLogoutFunction();
    var items = [
        { name: 'Home', link: '/' },
        { name: 'Orgs', link: '/orgs' },
        { name: 'Users', link: '/user_info' },
        { name: 'Dashboard', link: '/health' },
        { name: 'Settings', link: '/settings' },
    ]

    var listItems = items.map(item => {
        return (
            <li key={item.name}>
                <a href={item.link}>{item.name}</a>
            </li>
        );
    });

    return (
        <div>
            <div style={{ height: '70px' }}></div> {/* Placeholder */}
            <nav className='nav-main'>
                <div style={{ display: "flex", alignItems: "center" }}>
                    <img src="https://gcdnb.pbrd.co/images/ttmtj4NXkg5S.png" alt="logoede" style={{ marginRight: "10px" }} />
                    <h1 style={{ color: "#fff", fontSize: "24px", margin: 0 }}>My Health</h1>
                </div>
                <ul className='ul-simple'>
                    {listItems}
                    <li><button onClick={() => logoutFn(true)} className='logout-button'>Logout</button></li>
                </ul>
            </nav>
        </div>
    );
}

export default Navigation;
