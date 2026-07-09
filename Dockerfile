FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install

# copy project
COPY . . 

# prisma generate
RUN npx prisma generate

# build next
RUN npm run build

RUN cp -r .next/static .next/standalone/.next/static
RUN cp -r public/. .next/standalone/public/

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", ".next/standalone/server.js"]
