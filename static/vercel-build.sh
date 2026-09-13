#!/usr/bin/env bash
# Vercel이 build 때 실행하는 진입점입니다. (root의 vercel.json 이 이 script를 부릅니다)
#
# invitation.conf 는 개인정보(이름, 예식 정보, 계좌번호)라 git에 없습니다.
# 대신 Vercel 프로젝트의 Environment Variables 에 INVITATION_CONF 라는 이름으로
# invitation.conf 파일 내용 전체를 붙여넣으면, 이 script가 그 값으로 invitation.conf 를
# 만든 뒤 build.sh 를 돌립니다. 값은 Vercel에만 저장되고 git에는 올라가지 않습니다.
#
#   Vercel 대시보드 > Settings > Environment Variables
#     Name:  INVITATION_CONF
#     Value: invitation.conf 파일 내용 전체 (KEY="value" 줄들)
#
# conf를 고쳤으면 이 환경변수 값을 갱신하고 Redeploy 해야 반영됩니다.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

: "${INVITATION_CONF:=}"
echo "vercel-build.sh: INVITATION_CONF 길이 = ${#INVITATION_CONF} 자 (값 자체는 출력하지 않습니다)"

if [ -n "${INVITATION_CONF:-}" ]; then
  printf '%s\n' "$INVITATION_CONF" > invitation.conf
elif [ ! -f invitation.conf ]; then
  echo "vercel-build.sh: invitation.conf 가 없고 INVITATION_CONF 환경변수도 없습니다." >&2
  echo "Vercel 프로젝트 설정 > Environment Variables 에 INVITATION_CONF 를 등록해 주시기 바랍니다." >&2
  exit 1
fi

./build.sh
