const WebSocket = require('ws');

const port = 8080;
const wss = new WebSocket.Server({port: port});


const ConnectionType =
    {
        CUSTOMER: 'CUSTOMER',
        ADVISER: 'ADVISER',
    };


const MsgType = {
    INTRODUCTION: 'INTRODUCTION',
    FROM_ADVISER: 'FROM_ADVISER',
    CHOICE: 'CHOICE',
    NAME: 'NAME',
    FROM: 'FROM_CUSTOMER',
    CONNECTION_TYPE: 'CONNECTION_TYPE',
    CONNECT_WITH_CUSTOMER: 'CONNECT_WITH_CUSTOMER',
    NEW_CUSTOMER: 'NEW_CUSTOMER',
    CONNECTED_WITH_CUSTOMER: 'CONNECTED_WITH_CUSTOMER',
    MESSAGE_TO_CUSTOMER: 'MESSAGE_TO_CUSTOMER',
    CLOSE_CONNECTION: 'CLOSE_CONNECTION',
    FROM_CUSTOMER: 'FROM_CUSTOMER',
    LOOKING_FOR_ADVISER: 'LOOKING_FOR_ADVISER',
    NEW_CONVERSATION: 'NEW_CONVERSATION'
};


const IntroOptions = [
    {id: "1", msg: "I have technical problem."},
    {id: "2", msg: "I wish to speak with someone."},
    {id: "3", msg: "I'm just browsing."}

];



/* Some helper functions */
const findClients = () => connections.filter(({connectionType}) => connectionType === ConnectionType.CUSTOMER);
const findAdvisers = () => connections.filter(({connectionType}) => connectionType === ConnectionType.ADVISER);
const findById = val => connections.filter(({id}) => id === val)[0];
const sendMessage = (conn, type, msg) => (conn.send(JSON.stringify({type: type, msg: msg})));
const adviser = (avatar, name, isBot) => ({avatar: avatar, name: name, isBot: isBot});
const sendFromAdviser = (conn, adviser, msg) => sendMessage(conn, MsgType.FROM_ADVISER, {adviser: adviser, msg: msg});
const bot = adviser("https://randomuser.me/api/portraits/men/83.jpg", "DigBot", true);
const human = adviser("https://randomuser.me/api/portraits/women/13.jpg", "Adviser", false);


var ID = 0;
const connections = [];

wss.on('connection', function connection(ws) {

    ws.id = ID++;
    connections.push(ws);

    ws.on('message', function incoming(message) {
        const {type, msg} = JSON.parse(message);

        // Save type (adviser or customer) of the connection
        if (type === MsgType.CONNECTION_TYPE) {
            findById(ws.id).connectionType = msg;

            if (msg === ConnectionType.CUSTOMER) {
                sendMessage(ws, MsgType.INTRODUCTION, bot.name);
                sendFromAdviser(ws, bot, `Hi there. My name is ${bot.name}. How should I call you?`);
            }
            else if (msg === ConnectionType.ADVISER) {
                sendMessage(ws, MsgType.INTRODUCTION, `Hi there.`);
            }
        }

        // Save name of the customer
        else if (type === MsgType.NAME) {
            findById(ws.id).name = msg;
            sendFromAdviser(ws, bot, `Nice to meet you ${msg}. How can I help you?`);
            sendMessage(ws, MsgType.CHOICE, IntroOptions);
        }

        // Start new conversation between customer, by cleaning existing ones
        else if (type === MsgType.NEW_CONVERSATION) {
            findById(ws.id).adviser = undefined;
            findAdvisers().filter(({customer}) => customer === ws.id).forEach(conn => conn.customer = undefined);
            sendMessage(ws, MsgType.INTRODUCTION, bot.name);
            sendFromAdviser(ws, bot, "Hi there. My name is DigBot. How should I call you?");
        }

        // Deal with bot options
        else if (type === MsgType.CHOICE) {
            if (msg === IntroOptions[2].id) {
                sendFromAdviser(ws, bot, "I see. Let me know if you have any questions.");
            }
            else if (msg === IntroOptions[1].id) {
                if (findAdvisers().length === 0) {
                    sendFromAdviser(ws, bot, `I am very sorry, but at the moment everyone is offline.`);
                    sendFromAdviser(ws, bot, `Please tell me again your issue. I will do my best to sort it for you.`);
                    sendMessage(ws, MsgType.CHOICE, IntroOptions);
                }
                else {
                    sendFromAdviser(ws, bot, `Someone will be shortly with you.`);
                    sendMessage(ws, MsgType.LOOKING_FOR_ADVISER, "");
                    findAdvisers().filter(({customer}) => customer === undefined)
                        .forEach(conn => sendMessage(conn, MsgType.NEW_CUSTOMER, "New customer has connected."));
                }
            }
            else {
                sendFromAdviser(ws, bot, "Sorry, but this option is not implemented yet. ");
                sendMessage(ws, MsgType.CHOICE, IntroOptions);
            }
        }

        // Connect adviser to first available customer
        else if (type === MsgType.CONNECT_WITH_CUSTOMER) {
            const clients = findClients().filter(({adviser}) => adviser === undefined);
            if (clients.length !== 0) {
                clients[0].adviser = ws.id;
                findById(ws.id).customer = clients[0].id;
                sendMessage(ws, MsgType.CONNECTED_WITH_CUSTOMER, `You have been connected with ${clients[0].name}`);
                sendMessage(clients[0], MsgType.INTRODUCTION, adviser.name);
            }
        }

        // Send message to customer from adviser
        else if (type === MsgType.MESSAGE_TO_CUSTOMER) {
            const clients = findClients().filter(({adviser, id}) => adviser !== undefined && id === ws.customer);
            if (clients.length !== 0) {
                sendFromAdviser(clients[0], human, msg);
            }
        }

        // Respectively, send message from customer to adviser
        else if(type === MsgType.FROM_CUSTOMER) {
            const advisers = findAdvisers().filter(({customer, id}) => customer !== undefined && id === ws.adviser);
            if (advisers.length !== 0) {
                sendMessage(advisers[0], MsgType.FROM_CUSTOMER, msg);
            }
        }

        // Close connection between adviser and customer, atm only adviser can do this.
        else if (type === MsgType.CLOSE_CONNECTION) {
            const conn = findById(ws.id);
            if(conn.connectionType === ConnectionType.ADVISER) {
                const client = findById(conn.customer);
                client.adviser = undefined;
                conn.customer = undefined;
                sendMessage(client, MsgType.INTRODUCTION, bot.name);
                sendFromAdviser(client, bot, "Hope you have enjoyed talking with support.");
                sendMessage(client, MsgType.CHOICE, IntroOptions);
            }
        }
    })
});



