import unittest

target = __import__("aws-cli")
validate_region = target.validate_region
list_regions = target.list_regions
list_instances = target.list_instances

class TestValidateRegion(unittest.TestCase):
    def test_validate_region_empty_list(self):
        result = validate_region("us-east-1",[])
        self.assertFalse(result)
    def test_validate_region_not_matching(self):
        result = validate_region("us-east-1",["region1", "region2"])
        self.assertFalse(result)
    def test_validate_region_matching(self):
        result = validate_region("us-east-1",["region1", "region2", "us-east-1"])
        self.assertTrue(result)
    def test_validate_region_no_list(self):
        # with self.assertRaises(TypeError):
        result = validate_region("us-east-1", 3)
        self.assertFalse(result)
    def test_validate_region_bad_input(self):
        with self.assertRaises(TypeError):
            result = validate_region("us-east-1")

class TestListRegions(unittest.TestCase):
    def test_list_regions_invalid_argument(self):
        with self.assertRaises(TypeError):
            result = list_regions("region1")

class TestListInstances(unittest.TestCase):
    def test_list_instances_returns_list_type(self):
        result = list_instances("us-east-2")
        self.assertEqual(result.__class__, list)
    def test_list_instances_no_region(self):
        with self.assertRaises(TypeError):
            result = list_instances()
if __name__ == '__main__':
    unittest.main()