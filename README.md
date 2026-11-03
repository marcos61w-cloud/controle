# MARQO CONTROL

Sistema privado de controle de estoque, compras, vendas e indicadores financeiros.

## Tecnologias
- React + TypeScript + Vite
- Supabase Auth e PostgreSQL com Row Level Security
- jsPDF para relatórios
- Lucide para ícones

## Rodar localmente
1. Instale Node.js LTS.
2. Clone o repositório e instale dependências:
   `npm install`
3. Copie `.env.example` para `.env` e informe `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`.
4. No Supabase, execute `supabase/schema.sql` pelo SQL Editor.
5. Em Authentication, crie manualmente o usuário administrador e desative o cadastro público.
6. Rode `npm run dev`.

## Publicação
Publique o projeto em Vercel ou Netlify e configure as mesmas variáveis de ambiente. Cadastre a URL publicada nas configurações de URL/redirect do Supabase Auth.

## Segurança
- Nunca coloque a chave `service_role` no frontend.
- A chave anon/public é apropriada para o cliente somente com RLS corretamente habilitado.
- Restrinja a criação de usuários a convite/administração e mantenha o cadastro público desligado.
- Configure MFA no provedor quando possível.

## Estado atual
A primeira versão inclui login por e-mail/senha e Google, painel, cadastro de produto por lote, registro de venda, atualização de quantidade, cálculo de indicadores, preferências e exportação básica de estoque em PDF.

Ainda precisam ser implementados e testados antes do uso operacional: importação/OCR/XML de notas, edição e estorno com transações no banco, fluxo de caixa completo e conciliação, relatório financeiro/mensal em PDF, envio de e-mail, WhatsApp Cloud API, agendamento mensal, backups e testes automatizados. O formulário de configurações atualmente salva preferências; não envia mensagens por si só.

## Integrações futuras
- E-mail: Resend ou SMTP por função server-side.
- WhatsApp: Meta WhatsApp Cloud API por função server-side, com token guardado em secrets, envio de documentos e templates aprovados quando aplicável.
- Agendamentos: Supabase Edge Functions + Scheduled Triggers/cron.

Nunca colocar tokens ou segredos de integração em variáveis `VITE_*`, pois elas são expostas ao navegador.
