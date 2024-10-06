import boto3
import os

from .errors import StoppingInstance

INSTANCE_ID = os.environ.get("INSTANCE_ID")
EC2 = boto3.client('ec2')


def start():
    EC2.start_instances(
        InstanceIds=[
            INSTANCE_ID,
        ]
    )


def can_start_instance():
    res = EC2.describe_instance_status(
        InstanceIds=[
            INSTANCE_ID,
        ],
    )

    if not res or not len(res["InstanceStatuses"]):
        return True

    instance_state = res["InstanceStatuses"][0]["InstanceState"]["Name"]
    print(f"{instance_state=}")

    if instance_state in ["pending", "running"]:
        return False
    elif instance_state in ["shutting-down", "stopping"]:
        raise StoppingInstance("終了処理中")
    else:
        return True
