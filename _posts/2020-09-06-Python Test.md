---
layout:     post
title:      python Test
subtitle:   
date:       2020-09-06
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

Property-based automated testing with Hypothesis

## Strategies
A strategy defines the data that Hypothesis generates for testing

    #data_strategies.py
    from dataclasses import dataclass
    import hypothesis.strategies as st

    @dataclass
    class GeneratedData:
        float_value: st.SearchStrategy[float]

    generated_data = GeneratedData(float_value=st.floats(min_value=0.0, max_value=10.0))


## Setting
suppress_health_check: Allows you to specify which “health checks” to ignore
deadline: Specifies how long an individual example is allowed to take
max_examples: Controls how many passing examples are required before testing is concluded

    from hypothesis import given, settings, HealthCheck
    import hypothesis.strategies as st
    from my_functions import convert_to_integer
    from tests.data_strategies import generated_data

    settings.register_profile(
        "my_profile",
        max_examples=200,
        deadline=60 * 1000,  # Allow 1 min per example (deadline is specified in milliseconds)
        suppress_health_check=(HealthCheck.too_slow, HealthCheck.data_too_large),
    )

    @given(st.data())
    @settings(settings.load_profile("my_profile"))
    def test_convert_to_integer(test_data: st.DataObject):

        my_float = test_data.draw(generated_data.float_value)
        float_to_int = convert_to_integer(my_float)
        assert isinstance(float_to_int, int)

## composite strategies
### generate scenario
    from dataclasses import dataclass
    from typing import Any, Dict, Callable
    import hypothesis.strategies as st

    @dataclass
    class GeneratedData:
        array_length: st.SearchStrategy[int]
        dist: st.SearchStrategy[Callable]
        perc: st.SearchStrategy[float]

    @st.composite
    def generate_scenario(draw, settings: Any) -> Dict[str, Any]:
        """
        Generate a testing scenario for the percentile function.
        :param draw: Hypothesis object used to draw examples.
        :param settings: Setting for the generation of test data.
        :return: A tuple of two generated texts.
        """
        dist = draw(settings.dist)
        n = draw(settings.array_length)
        arr = dist(size=n)
        perc = draw(settings.perc)
        return {"values": arr, "perc": perc}

### testing
    import hypothesis.strategies as st
    from hypothesis import given, settings, assume
    import numpy as np
    from percentile import calc_percentile
    from tests.percentile_strategies import GeneratedData, generate_scenario

    settings.register_profile(
        "my_profile",
        max_examples=10000,
        deadline=60 * 1000,  # Allow 1 min per example (deadline is specified in milliseconds,
    )

    SETTINGS = GeneratedData(
        array_length=st.integers(2, 50000),
        dist=st.sampled_from([np.random.uniform, np.random.normal]),
        perc=st.floats(0.0, 1.0),
    )

    @given(st.data())
    @settings(settings.load_profile("my_profile"))
    def test_calc_percentile(data: st.DataObject) -> None:
        """
        Test the percentile function.
        :param data: Hypothesis DataObject that is used to draw from our strategies.
        """
        test_data = data.draw(generate_scenario(settings=SETTINGS))
        # Property 1: Order should not matter
        my_perc_val = calc_percentile(arr=test_data["values"], perc=test_data["perc"])
        # Invert the order of values
        inv_my_perc_val = calc_percentile(arr=test_data["values"][::-1], perc=test_data["perc"])
        assert my_perc_val == inv_my_perc_val
        # Property 2: Value should be equivalent to existing implementation
        # Numpy implementation
        numpy_per_val = np.percentile(a=test_data["values"], q=test_data["perc"] * 100, interpolation="midpoint")
        # Validate that the values are equivalent
        assert my_perc_val == numpy_per_val
