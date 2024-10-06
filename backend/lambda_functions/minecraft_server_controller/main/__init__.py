# from pathlib import Path

from .ec2 import start, can_start_instance
from .errors import InstanceIdNotFount, BootingUpInstance, StoppingInstance

HEADER = {
  'Content-Type': 'application/json; charset=utf-8',
}


def handler(event, __):
    print(event)

    try:
        # path = Path(event["path"])

        if not can_start_instance():
            raise BootingUpInstance("起動済みです！\niPadやiPhoneのマインクラフトで遊べます")

        start()

        return {
            'statusCode': 200,
            'body': '起動しました！\niPadやiPhoneのマインクラフトで遊べます',
            'headers': HEADER,
        }
    except (InstanceIdNotFount, BootingUpInstance, StoppingInstance) as e:
        return {
            'statusCode': 400,
            'body': str(e),
            'headers': HEADER,
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 200,
            'body': '起動失敗しました…\n少し待ってからもう一度試してください',
            'headers': HEADER,
        }
