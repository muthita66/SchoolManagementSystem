const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  await prisma.$executeRawUnsafe('ALTER TABLE student_health_checkups ADD COLUMN teeth_brushing VARCHAR(50), ADD COLUMN milk_drinking VARCHAR(50);');
  console.log('Columns added!');
}

main().catch(console.error).finally(() => prisma.$disconnect());
