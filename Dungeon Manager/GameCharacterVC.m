//
//  GameCharacterVC.m
//  Dungeon Manager
//
//  Created by Andrew Rodgers on 2/6/14.
//  Copyright (c) 2014 EnhanceDailyLife. All rights reserved.
//

#import "GameCharacterVC.h"
#import "getDocumentsDirectory.h"

@interface GameCharacterVC ()
{
    CGFloat slideheight;
}

@property (strong, nonatomic) GameCharacterVC *returner;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//0
@property (weak, nonatomic) IBOutlet UITextField *classTextField;//1
@property (weak, nonatomic) IBOutlet UITextField *raceTextField;//2
@property (weak, nonatomic) IBOutlet UITextField *levelTextField;//3
@property (weak, nonatomic) IBOutlet UITextField *XPTextField;//4
@property (weak, nonatomic) IBOutlet UITextField *homelandTextField;//5
@property (weak, nonatomic) IBOutlet UITextField *deityTextField;//6
@property (weak, nonatomic) IBOutlet UITextField *alignmentTextField;//7
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;//8
@property (weak, nonatomic) IBOutlet UITextField *maxHPTextField;//9
@property (weak, nonatomic) IBOutlet UITextField *currentHPTextField;//10
@property (weak, nonatomic) IBOutlet UITextField *initiativeTextField;//11
@property (weak, nonatomic) IBOutlet UITextField *babTextField;//12
@property (weak, nonatomic) IBOutlet UITextField *spellResistanceTextField;//13
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;//14
@property (weak, nonatomic) IBOutlet UITextField *armorClassTextField;//21 OUT OF ORDER
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;//15
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;//16
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;//17
@property (weak, nonatomic) IBOutlet UITextField *hairColorTextField;//18
@property (weak, nonatomic) IBOutlet UITextField *eyeColorTextField;//19
@property (weak, nonatomic) IBOutlet UITextField *skinColorTextField;//20


@property (weak, nonatomic) IBOutlet UITextView *BioTextView;//0


@property (strong, nonatomic) IBOutlet UICollectionView *attributeCollection;//0
@property (strong, nonatomic) IBOutlet UICollectionView *skillsCollection;//1

@end

@implementation GameCharacterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.classTextField.delegate = self;
    self.raceTextField.delegate = self;
    self.levelTextField.delegate = self;
    self.XPTextField.delegate = self;

    self.BioTextView.delegate = self;
    
    self.nameTextField.text = self.character.characterName;
    self.classTextField.text = self.character.primaryClass;
    self.raceTextField.text = self.character.race;
    
    
    self.BioTextView.text = self.character.bio;
    
    
    self.attributeCollection.delegate = self;
    self.attributeCollection.dataSource = self;
    self.skillsCollection.delegate = self;
    self.skillsCollection.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Buttons and the delete method

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newAttributeButton:(id)sender
{
    AttributeData *attribute = [[AttributeData alloc] init];
    attribute.attributeName = @"New";
    attribute.attributeValue = 0;
    
    if ([sender tag] == 0)
    {
        if (!self.character.coreAttributes)
        {
            self.character.coreAttributes = [NSMutableArray array];
        }
        [self.character.coreAttributes addObject:attribute];
        [self.attributeCollection reloadData];
    }
    if ([sender tag] == 1)
    {
        if (!self.character.classSkills)
        {
            self.character.classSkills = [NSMutableArray array];
        }
        attribute.secondaryAttribute = @"New";
        [self.character.classSkills addObject:attribute];
        [self.skillsCollection reloadData];
    }
    
    [self.delegate saveCharacters];
}

-(void)deleteAttributeOfType:(NSInteger)type atIndex:(NSInteger)index
{
    if (type == 0)
    {
        [self.character.coreAttributes removeObjectAtIndex:index];
    }
    if (type == 1)
    {
        [self.character.classSkills removeObjectAtIndex:index];
    }
    
    [self.delegate saveCharacters];
    [self.attributeCollection reloadData];
}

#pragma mark -CollectionViews

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttributeCell *cell;
    if (collectionView.tag == 0)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attributeCell" forIndexPath:indexPath];
        cell.attribute = self.character.coreAttributes[indexPath.row];
    }
    else if (collectionView.tag == 1)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"skillsCell" forIndexPath:indexPath];
        cell.attribute = self.character.classSkills[indexPath.row];
    }
    
    cell.attribute.attributeType = collectionView.tag;
    [cell buildView];
    cell.delegate = self.delegate;
    cell.deletionDelegate = self;
    cell.attribute.attributeIndex = [indexPath row];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 0)
    {
        return self.character.coreAttributes.count;
    }
    return 0;
}

#pragma mark -TextField and TextView editing

- (void)textFieldDidBeginEditing:(UITextField *)textField //Slides the view up when the keyboard appears
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + (CGFloat)0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - (CGFloat)0.2 * viewRect.size.height;
    CGFloat denominator = (CGFloat)0.6 * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        slideheight = floor((CGFloat)216 * heightFraction);
    }
    else
    {
        slideheight = floor((CGFloat)168 * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= slideheight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGFloat)0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += slideheight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGFloat)0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    if (textField.tag == 0)
    {
        self.character.characterName = textField.text;
    }
    else if (textField.tag == 1)
    {
        self.character.primaryClass = textField.text;
    }
    else if (textField.tag == 2)
    {
        self.character.race = textField.text;
    }
    else if (textField.tag == 3)
    {
        self.character.primaryLevel = [textField.text integerValue];
    }
    else if (textField.tag == 4)
    {
        self.character.xp = [textField.text integerValue];
    }
    else if (textField.tag == 5)
    {
        self.character.homeland = textField.text;
    }
    else if (textField.tag == 6)
    {
        self.character.deity = textField.text;
    }
    else if (textField.tag == 7)
    {
        self.character.alignment = textField.text;
    }
    else if (textField.tag == 8)
    {
        self.character.age = [textField.text integerValue];
    }
    else if (textField.tag == 9)
    {
        self.character.maxHealth = [textField.text integerValue];
    }
    else if (textField.tag == 10)
    {
        self.character.currentHealth = [textField.text integerValue];
    }
    else if (textField.tag == 11)
    {
        self.character.initiativeModifier = [textField.text integerValue];
    }
    else if (textField.tag == 12)
    {
        self.character.baseAttackBonus = [textField.text integerValue];
    }
    else if (textField.tag == 13)
    {
        self.character.spellResistance = [textField.text integerValue];
    }
    else if (textField.tag == 14)
    {
        self.character.currency = [textField.text integerValue];
    }
    else if (textField.tag == 21)
    {
        self.character.armorClass = [textField.text integerValue];
    }
    else if (textField.tag == 15)
    {
        self.character.gender = textField.text;
    }
    else if (textField.tag == 16)
    {
        self.character.height = textField.text;
    }
    else if (textField.tag == 17)
    {
        self.character.weight = textField.text;
    }
    else if (textField.tag == 18)
    {
        self.character.hairColor = textField.text;
    }
    else if (textField.tag == 19)
    {
        self.character.eyeColor = textField.text;
    }
    else if (textField.tag == 20)
    {
        self.character.skinColor = textField.text;
    }
    
    [self.delegate saveCharacters];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.character.bio = textView.text;
    [self.delegate saveCharacters];
}

#pragma mark -Swipe View Methods

- (IBAction)showNextView:(id)sender
{
    NSInteger nextIndex = [self.formView currentItemIndex] + 1;
    [self.formView scrollToItemAtIndex:nextIndex duration:0.4];
}

- (IBAction)showPreviousView:(id)sender
{
    NSInteger nextIndex = [self.formView currentItemIndex] -1;
    [self.formView scrollToItemAtIndex:nextIndex duration:0.4];
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return 8;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    GameCharacterVC *returner;
    if (index == 1)
    {
        returner = [[GameCharacterVC alloc] initWithNibName:@"NameView" bundle:nil];
        returner.character = self.character;
        return returner.view;
    }
    if (index == 2)
    {
        returner = [[GameCharacterVC alloc] initWithNibName:@"BackgroundView" bundle:nil];
        returner.character = self.character;
        return returner.view;
    }
    if (index == 3)
    {
        returner = [[GameCharacterVC alloc] initWithNibName:@"PhysicalView" bundle:nil];
        returner.character = self.character;
        return returner.view;
    }
    if (index == 4)
    {
        returner = [[GameCharacterVC alloc] initWithNibName:@"Statistics1View" bundle:nil];
        returner.character = self.character;
        return returner.view;
    }
    if (index == 5)
    {
        returner = [[GameCharacterVC alloc] initWithNibName:@"AttributeView" bundle:nil];
        returner.character = self.character;
        return returner.view;
    }
    if (index == 6)
    {
        returner = [[GameCharacterVC alloc] initWithNibName:@"SkillsView" bundle:nil];
        returner.character = self.character;
        return returner.view;
    }
    UIView *stuff = [[UIView alloc] initWithFrame:swipeView.frame];
    stuff.backgroundColor = [UIColor blueColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 120, 120)];
    label.text = [NSString stringWithFormat:@"view number %d", index];
    [stuff addSubview:label];
    return stuff;
}

#pragma -Camera/Pictures

- (IBAction)startPicker:(id)sender
{
    UIActionSheet *mySheet;
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        mySheet = [[UIActionSheet alloc] initWithTitle:@"Pick Photo" delegate:self cancelButtonTitle:@"cancel"destructiveButtonTitle:nil otherButtonTitles: @"Camera", @"Photo Library", nil];
    }
    else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        mySheet = [[UIActionSheet alloc] initWithTitle:@"Pick Photo" delegate:self cancelButtonTitle:@"cancel"destructiveButtonTitle:nil otherButtonTitles: @"Photo Library", nil];
    }
    else
    {
        return;
    }
    
    [mySheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *myPicker = [[UIImagePickerController alloc] init];
    myPicker.delegate = self;
    myPicker.allowsEditing = YES;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"])
    {
        myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:myPicker animated:YES completion:nil];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage = [info objectForKey: UIImagePickerControllerEditedImage];
        self.characterImageView.image = editedImage;
        
        NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.5);
        self.character.avatarPath = [[getDocumentsDirectory docs] stringByAppendingString: [NSString stringWithFormat:@"/%@%@.jpeg", self.delegate.filePath, self.character.characterName]];
        [imageData writeToFile:self.character.avatarPath atomically:YES];
        [self.delegate saveCharacters];
    }];
}

@end
