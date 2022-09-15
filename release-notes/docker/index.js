import dotenv from "dotenv";
import moment from "moment";
import fetch from "node-fetch";

dotenv.config();

const NOTION_TOKEN = process.env.NOTION_TOKEN;
const NOTION_DATABASE_ID = process.env.NOTION_DATABASE_ID;
const PRODUCT = process.env.PRODUCT;
const RELEASE_TAG = process.env.RELEASE_TAG;
const RELEASE_NOTES = process.env.RELEASE_NOTES;

const options = {
  method: "POST",
  headers: {
    accept: "application/json",
    "Content-Type": "application/json",
    "Notion-Version": "2022-06-28",
    authorization: `Bearer ${NOTION_TOKEN}`,
  },
  body: JSON.stringify({
    parent: {
      type: "database_id",
      database_id: NOTION_DATABASE_ID,
    },
    properties: {
      Product: { title: [{ type: "text", text: { content: PRODUCT } }] },
      Version: {
        rich_text: [{ type: "text", text: { content: RELEASE_TAG } }],
      },
      "Release Date": {
        type: "date",
        date: {
          start: moment().format("YYYY-MM-DD"),
          end: null,
          time_zone: null,
        },
      },
    },
    children: [
      {
        type: "paragraph",
        paragraph: {
          rich_text: [{ type: "text", text: { content: RELEASE_NOTES } }],
        },
      },
    ],
  }),
};

fetch("https://api.notion.com/v1/pages", options)
  .then((response) => response.json())
  .then((response) => console.log(`Page Created: ${response.url}`))
  .catch((err) => console.error(err));
