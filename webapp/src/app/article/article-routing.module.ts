import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthGuard } from '../core';
import { NewComponent } from './new/new.component';
import { UpdateComponent } from './update/update.component';
import { ArticleResolver } from './article-resolver.service';

const routes: Routes = [
  {
    path: 'new',  // prefix '/article/', query: ?for=&ty=
    component: NewComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'update/:id',  // prefix '/article/'
    component: UpdateComponent,
    canActivate: [AuthGuard],
    resolve: {
      res: ArticleResolver
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ArticleRoutingModule {}
