import json

def handler(event, context):
    for record in event.get('Records', []):
        body = record.get('body', '')
        print(f"[LAMBDA] Mensagem recebida da fila SQS: {body}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Processado com sucesso!')
    }