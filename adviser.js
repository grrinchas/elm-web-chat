const WebSocket = require('ws');
var prompt = require('prompt-sync')();

const ws = new WebSocket('ws://localhost:8080');

ws.on('open', function open() {
    ws.send(JSON.stringify({type: "CONNECTION_TYPE", msg: "ADVISER"}));
});


ws.on('message', function incoming(message) {
    const {type, msg} = JSON.parse(message);

    if(type === "NEW_CUSTOMER") {
        console.log(msg);
        const res = prompt('Would you like to serve this customer [y/n]: ');
        if (res === "y") {
            ws.send(JSON.stringify({type: "CONNECT_WITH_CUSTOMER", msg: ""}));
        }
    }
    else if (type === "FROM_CUSTOMER") {
        console.log(msg);
        const result = prompt('Say something: ');
        if (result === ":close") {
            ws.send(JSON.stringify({type: "CLOSE_CONNECTION", msg: ""}));
        } else {
            ws.send(JSON.stringify({type: "MESSAGE_TO_CUSTOMER", msg: result}));
        }
    }
    else if (type === "CONNECTED_WITH_CUSTOMER") {
        console.log(msg);
        const result = prompt('Say something: ');
        if (result === ":close") {
            ws.send(JSON.stringify({type: "CLOSE_CONNECTION", msg: ""}));
        } else {
            ws.send(JSON.stringify({type: "MESSAGE_TO_CUSTOMER", msg: result}));
        }
    }
    else {
        console.log(msg);
    }
});

