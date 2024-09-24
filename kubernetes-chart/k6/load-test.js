import { check, sleep } from 'k6';
import http from 'k6/http';

export let options = {
  stages: [
    { duration: '30s', target: 10 }, // 10 usuários por 30 segundos
    { duration: '1m', target: 30 },  // Escala para 50 usuários por 1 minuto
    { duration: '30s', target: 100 }, // Escala para 100 usuários por 30 segundos
    { duration: '60s', target: 300 }, // Escala para 300 usuários por 60 segundos
  ],
};

export default function () {
  let res = http.get('http://localhost:3000/api-docs');
  check(res, {
    'status é 200': (r) => r.status === 200,
  });
  sleep(1);
}
