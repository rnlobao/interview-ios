# What changes would I make to the PicPay code review

## Service Layer

I would improve the application's error returns. We routinely encounter errors that we can't debug, so to ensure better readability, I would add a completion with an error for each possible failure. For example, when we can't transform the string into a URL:

```swift
guard let jsonData = data else {
    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
    return
}
```

I added session injection to facilitate testing.

## View Model

1. If we were to use any dependency injection tactics, I would make the service a variable and inject it through the init, also facilitating unit testing later.

2. If we were to use an MVVM-C, I would inject it into the coordinator.

3. I would remove the completion variable.

4. I wouldn't create another function to handle it.

5. I would handle the case where contacts come in nil.

```swift
func loadContacts(_ completion: @escaping ([Contact]?, Error?) -> Void) {
    service.fetchContacts { [weak self] (contacts, error) in
        guard let self else { return }
        
        if let error {
            completion(nil, error)
            return
        }
        
        if let contacts {
            completion(contacts, nil)
        } else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No contacts"]))
        }
    }
}
```

## Created Cells

For the cell class, I needed to better understand some things, such as:

1. How `imgView.translatesAutoresizingMaskIntoConstraints = false` works, which creates constraints automatically, trying to understand the context of the view. In other words, when we set the constraints manually, it's necessary to disable this property.

2. `contentMode`
    - `scaleToFill`: Scales to fill, even if this changes the image dimensions to fill the view.
    - `scaleAspectFit`: Scales to fill the view while maintaining proportions and not clipping anything.
    - `scaleAspectFill`: Scales to fill the view, maintaining proportion but clipping some parts of the view.

3. `clipsToBounds`: Whether content outside the defined view will be clipped or not.

### ACTUAL CHANGES

**In this class, I would create a function to configure the hierarchy and another to configure the constraints.**

- Add `private` to the vars as they should be open to editing but not modification.
- Add `numberOfLines = 0` to adapt the label size.
- Add a single `NSLayoutConstraint.activate` to avoid code repetition.

Now, the most difficult part for me is configuring the Cell, which should be its responsibility. For this, I created the following code:

![alt text](image-1.png)

Where the blue part is on a secondary thread to avoid disrupting the user's visual experience while loading the images. The red part updates the main thread with the already loaded image or a placeholder image.

## View Controller

1. Transform the `UserIdsLegacy` class into a struct because it doesn't need inheritance, doesn't need to be a reference type, struct occupies less memory (as it is stored in stack and not heap), besides not needing to worry about retain cycles.

2. Create extensions for the tableView protocols.

3. Create a function for hierarchy and one for constraints.

4. Add MARKS in the code.

5. In `loadData`, I would pass the responsibility of handling the threads to the ViewModel and add a `[weak self]` in the code.

# Final project checklist:

### ListContactService
- [ ] Make it conform to a protocol to facilitate testing.
- [ ] Add session as a parameter in the init.
- [ ] Add a completion with an error in case it can't transform the URL.
- [ ] Add a completion with an error in case there is no data.

### ListContactsViewModel
- [ ] Pass the service as a parameter to facilitate testing.
- [ ] Leave without a handle function and keep everything in one function.
- [ ] Handle the dispatch management.
- [ ] Create an error completion in case there are no contacts.

### ContactCell
- [ ] Set `numberOfLines` of `fullnameLabel` to 0.
- [ ] Separate functions for constraints and hierarchy.
- [ ] Use a single `NSLayoutConstraint.activate` to activate all constraints at once.
- [ ] Make visual items private.
- [ ] Create a public function to access these visual items.
- [ ] Load the photo asynchronously without being on the main thread to avoid stalling the app.
- [ ] Add a default photo while images are loading.

### ListContactsViewController
- [ ] Make `UserIdsLegacy` a struct.
- [ ] Comment the code.
- [ ] Possibly inject the ViewModel.
- [ ] Create a default function for `showAlert`.
- [ ] Correct the cell click logic along with `tableView.deselectRow(at: indexPath, animated: true)`.
