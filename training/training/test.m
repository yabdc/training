-(void)addStore:(NSString *)name phone:(NSString *)phone{
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Store" inManagedObjectContext:delegate.managedObjectContext];
    
    Store *insertStore=[[Store alloc] initWithEntity:entity insertIntoManagedObjectContext:delegate.managedObjectContext];
    
    insertStore.name = name;
    insertStore.tel = phone;
    NSError *error = nil;
    
    [delegate.managedObjectContext save:&error];
}