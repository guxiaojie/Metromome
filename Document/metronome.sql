DROP TABLE IF EXISTS "book";
CREATE TABLE "book" ("id" INTEGER PRIMARY KEY  NOT NULL , "name" TEXT, "price" INTERGER, "pieces" INTEGER, "author" TEXT, "description" TEXT);
INSERT INTO "book" VALUES(1,'钢琴曲选集',12,5,'付旻','本书收录了30首备受广大青少年喜爱的...');
DROP TABLE IF EXISTS "piece";
CREATE TABLE "piece" ("id" INTEGER PRIMARY KEY  NOT NULL , "book_id" INTEGER NOT NULL , "duration" INTEGER, "timeSignature" INTEGER, "description" TEXT, "number" INTEGER);
INSERT INTO "piece" VALUES(1,1,80,1,'崭新的世界 - A Whole New World（动画片“阿拉丁”主题曲）',1);
INSERT INTO "piece" VALUES(2,1,80,2,'美女与野兽 - Beauty And The Beast（动画片“美女与野兽”主题曲）',2);
