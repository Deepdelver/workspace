# Zigbee2MQTT Lamp Offline Troubleshooting

## Problem
Lampen (`light.wc_light`, `light.gang`) tonen "unavailable" in Home Assistant, terwijl andere Zigbee apparaten (sensoren, switches) gewoon werken.

## Symptomen
- Entities `light.wc_light` en `light.gang` tonen status "unavailable"
- Motion sensor (`binary_sensor.motion_wc_occupancy`) werkt wel
- Zigbee2MQTT bridge connection sensor toont "on"
- Automations voor beweging werken niet

## Root Cause
De Zigbee lampen zijn fysiek offline of niet meer actief in het Zigbee netwerk. Typische oorzaken:
1. Wandschakelaar staat uit → lamp krijgt geen stroom
2. Lamp defect of stekker eruit
3. Langdurige stroomuitval

**Diagnose:** Check `last_seen` in Zigbee2MQTT `state.json`:
```bash
ssh root@192.168.1.251 "cat /config/zigbee2mqtt/state.json"
```

Als `last_seen` een oude datum toont (bv. >1 dag geleden), is de lamp offline.

## Oplossing
1. **Fysieke wandschakelaar omzetten** (uit → 5 sec wachten → aan)
2. Alternatief: Via Home Assistant de bijbehorende switch aanzetten (indien aanwezig)
3. Wachten tot lamp opnieuw pairt met Zigbee2MQTT (kan 5-60 seconden duren)

## Voorbeeld Fix
WC lamp hersteld door switch aan te zetten:
```bash
curl -X POST -H "Authorization: Bearer <token>" \
  -d '{"entity_id": "switch.wc_switch_switch_1"}' \
  https://deepdelver.duckdns.org:8123/api/services/switch/turn_on
```

## Preventie
- Zorg dat wandschakelaars altijd aan blijven staan
- Overweeg slimme schakelaars die de stroom niet onderbreken
- Monitor `last_seen` in Zigbee2MQTT voor vroegtijdige detectie

## Tools
- Home Assistant API: `curl -H "Authorization: Bearer <token>" https://deepdelver.duckdns.org:8123/api/states/<entity>`
- Zigbee2MQTT state: `ssh root@192.168.1.251 "cat /config/zigbee2mqtt/state.json"`
- Zigbee2MQTT logs: `ssh root@192.168.1.251 "tail -f /config/zigbee2mqtt/log/2026-04-09.19-29-00/log.log"`

## Datum
2026-04-18
