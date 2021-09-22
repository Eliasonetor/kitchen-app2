using {ProductService} from '../srv/services';

annotate ProductService.Products with @odata.draft.enabled;
annotate ProductService.Products with @Common.SemanticKey: [product_ID];