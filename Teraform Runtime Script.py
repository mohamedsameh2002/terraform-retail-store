import json
import subprocess
import sys
from pathlib import Path

# =====================================================
# Terraform Project Paths
# =====================================================

BASE_DIR = Path(r"D:\workspace\retail-project\terraform-retail-store")

VPC_DIR = BASE_DIR / "01-vpc-module"
EKS_DIR = BASE_DIR / "02-eks-cluster"
DATA_DIR = BASE_DIR / "03-data-services"
OBSER_DIR = BASE_DIR / "04-observability"


# =====================================================
# Helper Functions
# =====================================================

def run(command, directory):
    """Run command and stop if any error occurs."""

    print(f"\n[{directory.name}] {' '.join(command)}")

    result = subprocess.run(command, cwd=directory)

    if result.returncode != 0:
        print(f"\nERROR while running: {' '.join(command)}")
        sys.exit(result.returncode)


def terraform_init(directory):
    print(f"\nInitializing {directory.name}...")
    run(["terraform", "init"], directory)


def has_resources(directory):
    """
    Returns True if Terraform state contains resources.
    Works with both local and S3 remote backend.
    """

    result = subprocess.run(
        ["terraform", "state", "list"],
        cwd=directory,
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        return False

    return bool(result.stdout.strip())


def apply(directory):
    print(f"\nApplying {directory.name}...")
    run(["terraform", "apply", "-auto-approve"], directory)


def destroy(directory):
    if has_resources(directory):
        print(f"\nDestroying {directory.name}...")
        run(["terraform", "destroy", "-auto-approve"], directory)
    else:
        print(f"\nNo resources found in {directory.name}. Skipping...")





def empty_s3_bucket(bucket_name):
    print(f"\nEmptying S3 bucket: {bucket_name}")

    def delete_items(query):
        # Get object versions / delete markers
        result = subprocess.run(
            [
                "aws",
                "s3api",
                "list-object-versions",
                "--bucket",
                bucket_name,
                "--query",
                query,
                "--output",
                "json",
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            return

        try:
            objects = json.loads(result.stdout)
        except json.JSONDecodeError:
            return

        if not objects:
            return

        payload = {"Objects": objects}

        subprocess.run(
            [
                "aws",
                "s3api",
                "delete-objects",
                "--bucket",
                bucket_name,
                "--delete",
                json.dumps(payload),
            ],
            check=False,
        )

    # Delete all object versions
    delete_items("Versions[].{Key:Key,VersionId:VersionId}")

    # Delete all delete markers
    delete_items("DeleteMarkers[].{Key:Key,VersionId:VersionId}")

    # Delete any remaining current objects
    subprocess.run(
        [
            "aws",
            "s3",
            "rm",
            f"s3://{bucket_name}",
            "--recursive",
        ],
        check=False,
    )
# tfstate-dev-us-east-1-1nt90y
    print("Bucket emptied successfully.")

# =====================================================
# Main
# =====================================================

def main():

    print("=" * 60)
    print("Terraform Automation")
    print("=" * 60)

    # Initialize both projects
    terraform_init(VPC_DIR)
    terraform_init(EKS_DIR)
    terraform_init(DATA_DIR)
    terraform_init(OBSER_DIR)

    # Check state
    vpc_exists = has_resources(VPC_DIR)
    eks_exists = has_resources(EKS_DIR)
    data_exists = has_resources(DATA_DIR)
    obser_exists = has_resources(OBSER_DIR)

    if vpc_exists and eks_exists and data_exists and obser_exists :

        print("\nInfrastructure detected.")
        print("Running DESTROY...\n")

        destroy(OBSER_DIR)
        
        destroy(DATA_DIR)

        destroy(EKS_DIR)

        destroy(VPC_DIR)

        empty_s3_bucket("tfstate-dev-us-east-1-1nt90y")

    else:

        print(f"\nLogging in to Public ECR...")
        print("\nNo infrastructure found.")
        print("Running APPLY...\n")

       
        apply(VPC_DIR)

        apply(EKS_DIR)

        apply(DATA_DIR)

        apply(OBSER_DIR)

    print("\n===================================")
    print("Finished Successfully.")
    print("===================================")


if __name__ == "__main__":
    main()


