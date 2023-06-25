# SpaceXLaunches

## Features

1. Data are loaded from REST SpaceX-API https://github.com/r-spacex/SpaceX-API. In app is used api for getting only past launches.

2. List sorting with three options and persist to next app launch:
    - `Alphabetically` (sort list by names of launches from A to Z)
    - `Most recent` (sort list by date of launch from newest to oldest)
    - `Oldest` (sort list by date of launch from oldest to newest)
    
3. Searching in names of launches

4. Alert message when something failed in loading data with try again button

## Mocking

By default, app uses live implementation, which calls REST API mentioned above.
Root view controller can be then initialized with `live` dependency like this.

``` swift
let navigationController = UINavigationController(
    rootViewController: PastLaunchesListViewController(
        viewModel: .live
    )
)
```

However, when you can't use celular data, wifi, or there is something wrong with live API, you can simulate data with `preview` dependency.

``` swift
let navigationController = UINavigationController(
    rootViewController: PastLaunchesListViewController(
        viewModel: .preview
    )
)
```

Also, you can try `failable` state to simulate error response from REST API. 
This currently shows alert popup with try again button, whose action even simulate response delay in random range from zero to two seconds.

``` swift
let navigationController = UINavigationController(
    rootViewController: PastLaunchesListViewController(
        viewModel: .failable
    )
)
```

