# Outline

数据库脚本语言 SQL(Structured Query Language), 一种用于管理和操作关系型数据库的标准语言

## auto_increment
`auto_increment` 是一种用于数据库表的属性, 用于自动生成唯一的数值

这在创建主键时非常有用, 因为它确保每次插入新记录时, 都能自动生成一个唯一的ID, 而不需要手动指定

每次插入新记录，`auto_increment` 字段的值都会自动递增，从而避免重复或冲突
```SQL
CREATE TABLE users (
    id INT AUTO_INCREMENT,
    name VARCHAR(255),
    PRIMARY KEY (id)
);
```

插入相关信息时：
```SQL
INSERT INTO users (name) VALUES ('Alice');
INSERT INTO users (name) VALUES ('Bob');
```

## database-schema-table 三级关系
schema 在 database 和 table 之间起到组织和管理的作用。可以想象, database 是一座城市，而 schema 是城市中的不同街区或社区, 每个街区内有许多房屋（tables）

Database（城市）：整个城市中包含所有的数据和资源

Schema（街区/社区）：将城市划分成不同的区域，每个区域有自己的规则和管理，组织不同的表结构和数据

Table（房屋）：具体存放数据的地方，每张表有自己的结构和数据
