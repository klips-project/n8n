SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE TABLE IF NOT EXISTS public.workflow_entity
(
    id SERIAL NOT NULL,
    name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    active boolean NOT NULL,
    nodes json NOT NULL,
    connections json NOT NULL,
    "createdAt" timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    "updatedAt" timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    settings json,
    "staticData" json,
    CONSTRAINT pk_eded7d72664448da7745d551207 PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.workflow_entity
    OWNER to n8n;

COPY public.workflow_entity (id, name, active, nodes, connections, "createdAt", "updatedAt", settings, "staticData") FROM stdin;
8	result_listener	f	[{"parameters":{},"name":"Start","type":"n8n-nodes-base.start","typeVersion":1,"position":[260,70]},{"parameters":{"queue":"results","options":{}},"name":"result listener","type":"n8n-nodes-base.rabbitmqTrigger","typeVersion":1,"position":[330,820],"credentials":{"rabbitmq":"rabbitcredentials"}},{"parameters":{"functionCode":"try {\\n  var task = JSON.parse(items[0].json.content);\\n  console.log('task', JSON.stringify(task));\\n  if (task && task.nextJob && task.nextJob.job) {\\n    task.job[task.nextJob.idx] = task.nextJob.job;\\n    delete task.nextJob;\\n  }\\n} catch (e) {\\n  console.log('exception: ', e, items[0]);\\n}\\nconsole.log(JSON.stringify(task));\\nitems[0].json.content = task;\\nreturn items;\\n\\n"},"name":"handle response and modify job json","type":"n8n-nodes-base.function","typeVersion":1,"position":[610,830]},{"parameters":{"queue":"job_queue","options":{}},"name":"send back to job queue to run next step in job","type":"n8n-nodes-base.rabbitmq","typeVersion":1,"position":[940,820],"credentials":{"rabbitmq":"rabbitcredentials"}},{"parameters":{"conditions":{"string":[{"value1":"={{$node[\\"handle response and modify job json\\"].json.content[\\"status\\"]}}","value2":"success"}]}},"name":"overall job success","type":"n8n-nodes-base.if","typeVersion":1,"position":[790,710]},{"parameters":{"functionCode":"console.log('Job done!');\\n\\nreturn items;"},"name":"return overall success","type":"n8n-nodes-base.function","typeVersion":1,"position":[1050,620]}]	{"result listener":{"main":[[{"node":"handle response and modify job json","type":"main","index":0}]]},"handle response and modify job json":{"main":[[{"node":"overall job success","type":"main","index":0}]]},"overall job success":{"main":[[{"node":"return overall success","type":"main","index":0}],[{"node":"send back to job queue to run next step in job","type":"main","index":0}]]}}	2021-06-11 12:08:43.203	2021-06-17 09:25:00.538	{}	\N
6	job_listener	f	[{"parameters":{},"name":"Start","type":"n8n-nodes-base.start","typeVersion":1,"position":[250,300]},{"parameters":{"queue":"job_queue","options":{}},"name":"job listener1","type":"n8n-nodes-base.rabbitmqTrigger","typeVersion":1,"position":[250,490],"credentials":{"rabbitmq":"rabbitcredentials"}},{"parameters":{"functionCode":"try {\\n  var task = JSON.parse(items[0].json.content);\\n\\n  // WORKAROUND for reading JSON content as next job\\n  if (task.fields) {\\n    task = task.content;\\n  }\\n\\n  // validate\\n  if (!task || !task.job || task.job.length < 1 || !task.emailAddress) {\\n    throw 'Invalid arguments given';\\n  }\\n  // create unique ID if necessary (on first run)\\n  if (!task.id) {\\n    task.id = parseInt(new Date() * Math.random(), 10);\\n  }\\n  //find next job entry that has not run yet (no status)\\n  var nextJobIdx = -1;\\n  var nextJobEntry;\\n  task.job.some(function (job, idx) {\\n    if (!job.status) {\\n      nextJobEntry = job;\\n      nextJobIdx = idx;\\n      return true;\\n    } else {\\n      task.status = 'success';\\n    }\\n  });\\n  console.log('next job: ' + nextJobEntry.type ? nextJobEntry.type : 'none');\\n} catch (e) {\\n  return [{ json: { error: e.toString() } }];\\n}\\ntask.nextJob = {\\n  job: nextJobEntry,\\n  idx: nextJobIdx\\n};\\nitems[0].json.content = task;\\nreturn items;\\n\\n"},"name":"Function returns next job name1","type":"n8n-nodes-base.function","typeVersion":1,"position":[520,500]},{"parameters":{"queue":"={{$node[\\"IF there is a next job1\\"].json.content[\\"nextJob\\"][\\"job\\"][\\"type\\"]}}","options":{}},"name":"send message to next queue1","type":"n8n-nodes-base.rabbitmq","typeVersion":1,"position":[1300,430],"credentials":{"rabbitmq":"rabbitcredentials"}},{"parameters":{"conditions":{"string":[],"boolean":[{"value1":"={{$node[\\"Function returns next job name1\\"].items[0].json.content.error}}","value2":true}]}},"name":"IF invalid job json1","type":"n8n-nodes-base.if","typeVersion":1,"position":[710,500]},{"parameters":{"options":{}},"name":"Send Email1","type":"n8n-nodes-base.emailSend","typeVersion":1,"position":[880,370],"disabled":true},{"parameters":{"conditions":{"boolean":[],"string":[{"value1":"={{$node[\\"Function returns next job name1\\"].json.content[\\"nextJob\\"][\\"job\\"][\\"type\\"]}}","operation":"notEqual","value2":"'none'"}]}},"name":"IF there is a next job1","type":"n8n-nodes-base.if","typeVersion":1,"position":[1040,520]}]	{"job listener1":{"main":[[{"node":"Function returns next job name1","type":"main","index":0}]]},"Function returns next job name1":{"main":[[{"node":"IF invalid job json1","type":"main","index":0}]]},"IF invalid job json1":{"main":[[{"node":"Send Email1","type":"main","index":0}],[{"node":"IF there is a next job1","type":"main","index":0}]]},"IF there is a next job1":{"main":[[{"node":"send message to next queue1","type":"main","index":0}]]}}	2021-06-11 12:07:47.117	2021-06-17 09:25:01.536	{}	\N
7	job_sender	f	[{"parameters":{},"name":"Start","type":"n8n-nodes-base.start","typeVersion":1,"position":[250,300]},{"parameters":{"queue":"job_queue","sendInputData":false,"message":"={\\n    \\"job\\": [\\n        {\\n            \\"type\\": \\"download\\",\\n            \\"datasetURI\\": \\"https://something\\"\\n        },\\n        {\\n            \\"type\\": \\"extract\\"\\n        }\\n    ],\\n    \\"emailAddress\\": \\"peter@tosh.com\\"\\n}","options":{"durable":true}},"name":"Send Job to rabbit","type":"n8n-nodes-base.rabbitmq","typeVersion":1,"position":[750,450],"credentials":{"rabbitmq":"rabbitcredentials"}}]	{"Start":{"main":[[{"node":"Send Job to rabbit","type":"main","index":0}]]}}	2021-06-11 12:08:22.7	2021-06-17 06:45:09.959	{}	\N
\.


SELECT pg_catalog.setval('public.workflow_entity_id_seq', 8, true);


