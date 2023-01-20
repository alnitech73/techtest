import sys
import argparse
import logging
import boto3
from botocore.exceptions import ClientError

def validate_region(region, region_list):
    if not type(region_list) is list:
        return False
    try: 
        if not region in region_list:
            return False
    except TypeError as e:
        logging.error(e)
        return False
    return True

# Function that returns the list of valid AWS regions. Used to validate region specified by the user.
# In case there is no default region set in credentials file will use "us-east-1" so the boto3.client doesn't error out.
def list_regions():
    try:
        region_list = []
        ec2 = boto3.client('ec2', region_name="us-east-1")
        # Retrieves all regions that  work with EC2
        regions = ec2.describe_regions()['Regions']
        for region in regions:
            region_list.append(region['RegionName'])
    except ClientError as e:
        logging.error(e)
        return "error listing regions"
    finally:
        ec2.close()
    return region_list

# Function that returns the list of all instances within the specied region.
# We could've printed out the instances here but it's better to return the list in case we want to do something with those instances.

# NOTE: Real instance hostname set depends on Hostname type: IP name (IPv4 only) / Resource name
# Using PrivateDnsName for now for the sake of functionality. 
# I don't see in boto3 describe_instances() a way to get the "Hostname type" for a better decision on what property to use for accurate hostname output
# See how Amazon EC2 sets the hostname: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
def list_instances(region):

    try:
        instance_list = []
        ec2 = boto3.client('ec2', region_name=region)
        reservations = ec2.describe_instances()["Reservations"]
        for reservation in reservations:
            for instance in reservation["Instances"]:
                instance_list.append(instance["PrivateDnsName"])
    except ClientError as e:
        logging.error(e)
        return "error listing instances"
    except TypeError as e:
        logging.error(e)
        return "missing region"
    finally:
        ec2.close()
    return instance_list

# Main function - parsing and validating arguments
def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("-r","--region", help="valid AWS region name", required=True)
    args = parser.parse_args()

    if not validate_region(args.region, list_regions()):
        print("ERR: Region provided is not a valid AWS region!")
        sys.exit(2)

    for instance in list_instances(args.region):
        print(instance)


if __name__ == "__main__":
    main()