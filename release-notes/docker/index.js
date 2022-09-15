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
    children: generateChildren(RELEASE_NOTES),
  }),
};

fetch(NOTION_API_HOST + NOTION_PAGE_API, options)
  .then((response) => response.json())
  .then((response) => console.log(`Page Created: ${response.url}`))
  .catch((err) => console.error(err));

function generateChildren(input) {
  const h1 = /^# (.*$)/gim;
  const h2 = /^## (.*$)/gim;
  const h3 = /^### (.*$)/gim;
  const ul = /^- (.*$)/gim;
  const ol = /^\d+. (.*$)/gim;
  const bq = /^\> (.*$)/gim;

  const content = input + "\n\n";
  var blocks = [];
  var codeBuffer = [];

  content.split("\n").forEach((line) => {
    if (line == "") {
      console.log(codeBuffer);
      if (codeBuffer.length > 0) {
        blocks.push(generateBlock(codeBuffer.join("\n"), "code"));
      }
      codeBuffer = [];
    } else if (line.match(h1)?.length > 0) {
      blocks.push(generateBlock(line.replace(h1, "$1"), "heading_1"));
    } else if (line.match(h2)?.length > 0) {
      blocks.push(generateBlock(line.replace(g2, "$1"), "heading_2"));
    } else if (line.match(h3)?.length > 0) {
      blocks.push(generateBlock(line.replace(h3, "$1"), "heading_3"));
    } else if (line.match(ol)?.length > 0) {
      blocks.push(generateBlock(line.replace(ol, "$1"), "numbered_list_item"));
    } else if (line.match(ul)?.length > 0) {
      blocks.push(generateBlock(line.replace(ul, "$1"), "bulleted_list_item"));
    } else if (line.match(bq)?.length > 0) {
      codeBuffer.push(line.replace(bq, "$1"));
    } else {
      blocks.push(generateBlock(line, "paragraph"));
    }
  });

  return blocks;
}

function generateBlock(input, type) {
  var block = {
    type: type,
  };

  block[type] = {
    rich_text: [
      {
        type: "text",
        text: {
          content: input,
          link: null,
        },
      },
    ],
  };

  return block;
}
