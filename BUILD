package(default_visibility = ["//visibility:public"])

constraint_setting(name = "core")
constraint_value(name = "cortex_m0", constraint_setting = "core")
constraint_value(name = "cortex_m0+", constraint_setting = "core")
constraint_value(name = "cortex_m1", constraint_setting = "core")
constraint_value(name = "cortex_m3", constraint_setting = "core")
constraint_value(name = "cortex_m4", constraint_setting = "core")
constraint_value(name = "cortex_m4s", constraint_setting = "core")
constraint_value(name = "cortex_m7", constraint_setting = "core")
constraint_value(name = "cortex_m23", constraint_setting = "core")
constraint_value(name = "cortex_m33", constraint_setting = "core")
constraint_value(name = "cortex_m35p", constraint_setting = "core")


platform(
    name = "base",
    constraint_values = [
        "@platforms//cpu:arm",
        "@platforms//os:none",
    ],
)

platform(
    name = "cm3",
    parents = [":base"],
    constraint_values = [
        ":cortex_m3",
    ],
)

platform(
    name = "cm4",
    parents = [":base"],
    constraint_values = [
        ":cortex_m4",
    ],
)

platform(
    name = "cm4s",
    parents = [":base"],
    constraint_values = [
        ":cortex_m4s",
    ],
)

platform(
    name = "cm23",
    parents = [":base"],
    constraint_values = [
        ":cortex_m23",
    ],
)

platform(
    name = "cm33",
    parents = [":base"],
    constraint_values = [
        ":cortex_m33",
    ],
)
