# การติดตั้งโปรเจกต์สำหรับสมาชิกทีม

## ใช้ฐานข้อมูลกลางที่มีอยู่แล้ว

1. ติดตั้ง Node.js 20 หรือใหม่กว่าและ Git
2. Clone หรือ pull repository
3. คัดลอก `.env.example` เป็น `.env`
4. กำหนด `DATABASE_URL` ให้ชี้ไปยัง PostgreSQL ของทีม และตั้ง `JWT_SECRET`
5. รันคำสั่งต่อไปนี้

```bash
npm install
npm run db:deploy
npm run db:generate
npm run dev
```

`db:deploy` ใช้ migration ที่ commit อยู่ใน repository และไม่ลบข้อมูลเดิม หากขึ้น `No pending migrations to apply.` ถือว่าฐานข้อมูลเป็นปัจจุบัน

## สร้างฐานข้อมูลใหม่

สร้าง PostgreSQL database เปล่า กำหนด `DATABASE_URL` ให้ชี้ไปยัง database นั้น แล้วรัน:

```bash
npm install
npm run db:deploy
npm run db:generate
npm run dev
```

Baseline migration จะสร้างโครงสร้างตารางทั้งหมดให้โดยอัตโนมัติ ฐานข้อมูลใหม่จะยังไม่มีข้อมูลผู้ใช้หรือนักเรียน

ใช้คำสั่ง seed เฉพาะเมื่อทีมตกลงว่าต้องการข้อมูลเริ่มต้น:

```bash
npx prisma db seed
```

ห้ามรัน seed กับฐานข้อมูลใช้งานจริงโดยไม่ตรวจสอบก่อน

## คำสั่งตรวจสอบ

```bash
npm run db:status
npx prisma validate
```

ไม่ควรใช้ `prisma db push` กับฐานข้อมูลกลาง เพราะคำสั่งนี้แก้ schema โดยไม่บันทึก migration history การเปลี่ยน schema ใหม่ควรสร้าง migration และ commit ไฟล์ใน `prisma/migrations` ทุกครั้ง
