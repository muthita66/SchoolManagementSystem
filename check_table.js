const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  try {
    const result = await prisma.$queryRawUnsafe("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'student_health_checkups';");
    console.log(result);
  } catch (err) {
    console.error(err);
  }
}

main().finally(() => prisma.$disconnect());
