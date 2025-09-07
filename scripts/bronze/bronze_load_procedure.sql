create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
	set @batch_start_time = getdate();
		print '=====================';
		print 'Loading bronze layer';
		print '=====================';

		print '---------------------';
		print 'Loading CRM Tables';
		print '---------------------';

		set @start_time = getdate();
		print '>>Truncating table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info; --to prevent duplicating data while loading
		print '>>Inserting data into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\MBRPLUS\Documents\SQL Server Management Studio 21\sql-data-warehouse-project\datasets\source_crm/cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration = ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds.';
		print '**********************'

		set @start_time = getdate();
		print '>>Truncating table: bronze.crm_prod_info';
		truncate table bronze.crm_prod_info; 
		print '>>Inserting data into: bronze.crm_prod_info';
		bulk insert bronze.crm_prod_info
		from 'C:\Users\MBRPLUS\Documents\SQL Server Management Studio 21\sql-data-warehouse-project\datasets\source_crm/prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration = ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds.';
		print '**********************'

		set @start_time = getdate();
		print '>>Truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		print '>>Inserting data into: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\MBRPLUS\Documents\SQL Server Management Studio 21\sql-data-warehouse-project\datasets\source_crm/sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration = ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds.';
		print '**********************'



		print '---------------------';
		print 'Loading ERP Tables';
		print '---------------------';

		set @start_time = getdate();
		print '>>Truncating table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		print '>>Inserting data into: bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\MBRPLUS\Documents\SQL Server Management Studio 21\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration = ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds.';
		print '**********************'

		set @start_time = getdate();
		print '>>Truncating table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		print '>>Inserting data into: bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\MBRPLUS\Documents\SQL Server Management Studio 21\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration = ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds.';
		print '**********************'

		set @start_time = getdate();
		print '>>Truncating table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		print '>>Inserting data into: bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\MBRPLUS\Documents\SQL Server Management Studio 21\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration = ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds.';
		set @batch_end_time = getdate();
		print '======================================';
		print 'Loading Bronze Layer is Completed';
		print '		-Total load Duration = ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds.';
		print '======================================';
	end try
	begin catch
		print '=========================';
		print 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		print 'ERROR MESSAGE' + error_message();
		print 'ERROR NUMBER' + cast(error_number() as nvarchar);

		print '=========================';
	end catch
end;
