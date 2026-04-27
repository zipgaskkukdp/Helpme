# 1. 가벼운 Node.js 환경 가져오기
FROM node:18-alpine

# 2. 작업할 폴더 지정
WORKDIR /usr/src/app

# 3. 소스 코드 복사하기
COPY app.js .

# 4. 앱이 사용할 포트 번호 열어두기
EXPOSE 3000

# 5. 컨테이너가 켜질 때 실행할 명령어
CMD ["node", "app.js"]