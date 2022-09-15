import dotenv from "dotenv";
import moment from "moment";
import fetch from "node-fetch";

dotenv.config();

const NOTION_API_HOST = "https://api.notion.com";
const NOTION_PAGE_API = "/v1/pages";
const NOTION_API_VERSION = "2022-06-28";
const NOTION_DATE_FORMAT = "YYYY-MM-DD";
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
    "Notion-Version": NOTION_API_VERSION,
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
          start: moment().format(NOTION_DATE_FORMAT),
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

fetch(NOTION_API_HOST + NOTION_PAGE_API, options)
  .then((response) => response.json())
  .then((response) => console.log(`Page Created: ${response.url}`))
  .catch((err) => console.error(err));
