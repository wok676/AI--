/**
 * 仅供本地开发/迁移验证:把 Postgres 版 schema 降级为 SQLite 版(SQLite 无原生 enum)。
 * 生产/契约基准始终是 prisma/schema.prisma(Postgres)。不纳入正式构建。
 */
const fs = require('fs');
const path = require('path');

const src = fs.readFileSync(path.join(__dirname, '..', 'prisma', 'schema.prisma'), 'utf8');
let s = src.replace('provider = "postgresql"', 'provider = "sqlite"');

const enumNames = [...s.matchAll(/enum\s+(\w+)\s*\{/g)].map((m) => m[1]);
// 删除 enum 块
s = s.replace(/enum\s+\w+\s*\{[^}]*\}\n?/g, '');
// 字段类型里的 enum 名降级为 String(匹配:换行 + 缩进 + 字段名 + 空白 + EnumName + 可选?)
for (const e of enumNames) {
  const re = new RegExp('(\\n\\s+\\w+\\s+)' + e + '(\\??)', 'g');
  s = s.replace(re, (_m, p1, opt) => p1 + 'String' + opt);
}
// 把 @default(ENUM_VALUE) 里的裸枚举字面量加引号(SQLite String 默认值须是字符串)
s = s.replace(/@default\(([A-Z][A-Z_]*)\)/g, '@default("$1")');
fs.writeFileSync(path.join(__dirname, '..', 'prisma', 'schema.sqlite.prisma'), s);
console.log('sqlite dev schema written; enums downgraded:', enumNames.join(','));
