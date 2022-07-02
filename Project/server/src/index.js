var koa = require('koa');
var app = module.exports = new koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server });
const Router = require('koa-router');
const cors = require('@koa/cors');
const bodyParser = require('koa-bodyparser');

app.use(bodyParser());

app.use(cors());

app.use(middleware);

function middleware(ctx, next) {
    const start = new Date();
    return next().then(() => {
        const ms = new Date() - start;
        console.log(`${start.toLocaleTimeString()} ${ctx.request.method} ${ctx.request.url} ${ctx.response.status} - ${ms}ms`);
    });
}


const getRandomInt = (min, max) => {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
};

const recipes = [];
const recipeName = ['R1', 'R2', 'R3'];
const ingredients = ['I1', 'I2', 'I3'];
const cookingSpecifications = ['CS1', 'CS2', 'CS3'];
const time = ['T1', 'T2', 'T3'];
const difficulty = ['D1', 'D2', 'D3'];
const calories = ['1.2', '2.2', '3.3'];

for (let i = 0; i < 3; i++) {
    recipes.push({
        id: i + 1,
        recipeName: recipeName[getRandomInt(0, recipeName.length)],
        ingredients: ingredients[getRandomInt(0, ingredients.length)],
        cookingSpecifications: cookingSpecifications[getRandomInt(0, cookingSpecifications.length)],
        time: time[getRandomInt(0, time.length)],
        difficulty: difficulty[getRandomInt(0, difficulty.length)],
        calories: calories[getRandomInt(0, calories.length)]
    });
}

const router = new Router();

router.get('/recipes', ctx => {
    recipes.forEach(element => {
        console.log("Get: " + element.id);
    });
    ctx.response.body = recipes;
    ctx.response.status = 200;
});

const broadcast = (data) =>
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(data));
        }
    });

router.post('/recipe', ctx => {
    const headers = ctx.request.body;
    console.log("Add: " + JSON.stringify(headers));
    const recipeName = headers.recipeName;
    const ingredients = headers.ingredients;
    const cookingSpecifications = headers.cookingSpecifications;
    const time = headers.time;
    const difficulty = headers.difficulty;
    const calories = headers.calories;

    if (typeof recipeName !== 'undefined' &&
        typeof ingredients !== 'undefined' &&
        typeof cookingSpecifications !== 'undefined' &&
        typeof time !== 'undefined' &&
        typeof difficulty !== 'undefined') {

        let maxId = Math.max.apply(Math, recipes.map(function(obj) {
            return obj.id;
        })) + 1;
        let obj = {
            id: maxId,
            recipeName,
            ingredients,
            cookingSpecifications,
            time,
            difficulty,
            calories
        };
        console.log("Was added: " + JSON.stringify(obj));
        recipes.push(obj);
        broadcast(obj);
        ctx.response.body = obj;
        ctx.response.status = 200;
    } else {
        console.log("Missing or invalid fields!");
        ctx.response.body = { text: 'Missing or invalid fields!' };
        ctx.response.status = 404;
    }
});

router.get('/recipe/:id', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = exams.findIndex(order => order.id == id);
        if (index === -1) {
            console.log("Recipe not available!");
            ctx.response.body = { text: 'Recipe not available!' };
            ctx.response.status = 404;
        } else {
            let obj = exams[index];
            ctx.response.body = obj;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = { text: 'Missing or invalid: id!' };
        ctx.response.status = 404;
    }
});

router.del('/recipe/:id', ctx => { // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    console.log("Delete: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = recipes.findIndex(obj => obj.id == id);
        if (index === -1) {
            console.log("No recipe with id: " + id);
            ctx.response.body = { text: 'Invalid recipe id.' };
            ctx.response.status = 404;
        } else {
            let obj = recipes[index];
            recipes.splice(index, 1);
            ctx.response.body = obj;
            ctx.response.status = 200;
        }
    } else {
        ctx.response.body = { text: 'Id missing or invalid' };
        ctx.response.status = 404;
    }
});

router.patch('/recipe', ctx => {
    const headers = ctx.request.body;
    console.log("Modify: " + JSON.stringify(headers));
    const id = parseInt(headers.id);
    const recipeName = headers.recipeName;
    const ingredients = headers.ingredients;
    const cookingSpecifications = headers.cookingSpecifications;
    const time = headers.time;
    const difficulty = headers.difficulty;
    const calories = headers.calories;

    if (typeof recipeName !== 'undefined' &&
        typeof ingredients !== 'undefined' &&
        typeof cookingSpecifications !== 'undefined' &&
        typeof time !== 'undefined' &&
        typeof difficulty !== 'undefined') {

        let obj = {
            id: id,
            recipeName,
            ingredients,
            cookingSpecifications,
            time,
            difficulty,
            calories
        };
        console.log(id);
        const index = recipes.findIndex(obj => obj.id == id);
        if (index != -1) {
            console.log("adasd");
            recipes[index] = obj;
            broadcast(obj);
            ctx.response.body = obj;
            ctx.response.status = 200;
        } else {
            console.log("Missing or invalid fields!");
            ctx.response.body = { text: 'Missing or invalid fields!' };
            ctx.response.status = 404;
        }

        //console.log("created: " + JSON.stringify(name));
    } else {
        console.log("Missing or invalid fields!");
        ctx.response.body = { text: 'Missing or invalid fields!' };
        ctx.response.status = 404;
    }
});

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2018);